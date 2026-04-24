#!/usr/bin/env python3
"""Extract date, total amount, and KDV from Turkish PDF invoices.

Text extraction uses the first available backend: pdfplumber, pypdf, or the
pdftotext CLI. Install one of them if your environment has no PDF extractor.
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from datetime import date
from decimal import Decimal, InvalidOperation
from pathlib import Path


MONEY_RE = re.compile(
    r"(?P<prefix>₺|TL|TRY)?\s*"
    r"(?P<amount>[+-]?(?:\d{1,3}(?:[.\s]\d{3})+|\d+)(?:[,.]\d{2})?)"
    r"\s*(?P<suffix>₺|TL|TRY)?",
    re.IGNORECASE,
)

DATE_PATTERNS = [
    re.compile(r"(?<!\d)(?P<d>\d{1,2})[./-](?P<m>\d{1,2})[./-](?P<y>\d{2,4})(?!\d)"),
    re.compile(r"(?<!\d)(?P<y>\d{4})-(?P<m>\d{1,2})-(?P<d>\d{1,2})(?!\d)"),
]

TOTAL_LABELS = [
    "ODENECEK TUTAR",
    "GENEL TOPLAM",
    "TOPLAM TUTAR",
    "FATURA TOPLAMI",
    "KDV DAHIL TOPLAM",
    "VERGILER DAHIL TOPLAM",
    "TOPLAM",
]

KDV_LABELS = [
    "HESAPLANAN KDV",
    "TOPLAM KDV",
    "KDV TUTARI",
    "KDV",
]

DATE_LABELS = ["FATURA TARIHI", "DUZENLEME TARIHI", "SENARYO TARIHI", "TARIH"]

TR_TRANSLATION = str.maketrans(
    {
        "ç": "c",
        "Ç": "C",
        "ğ": "g",
        "Ğ": "G",
        "ı": "i",
        "I": "I",
        "İ": "I",
        "ö": "o",
        "Ö": "O",
        "ş": "s",
        "Ş": "S",
        "ü": "u",
        "Ü": "U",
    }
)


@dataclass(frozen=True)
class MoneyMatch:
    value: Decimal
    raw: str
    start: int
    end: int


def normalize_tr(text: str) -> str:
    return text.translate(TR_TRANSLATION).upper()


def extract_text(pdf_path: Path) -> str:
    try:
        import pdfplumber  # type: ignore

        with pdfplumber.open(pdf_path) as pdf:
            return "\n".join(page.extract_text() or "" for page in pdf.pages)
    except ModuleNotFoundError:
        pass

    try:
        from pypdf import PdfReader  # type: ignore

        reader = PdfReader(str(pdf_path))
        return "\n".join(page.extract_text() or "" for page in reader.pages)
    except ModuleNotFoundError:
        pass

    if shutil.which("pdftotext"):
        completed = subprocess.run(
            ["pdftotext", "-layout", str(pdf_path), "-"],
            check=True,
            capture_output=True,
            text=True,
        )
        return completed.stdout

    raise RuntimeError("PDF text backend missing. Install pdfplumber, pypdf, or pdftotext.")


def parse_money(raw: str) -> Decimal | None:
    cleaned = re.sub(r"[^\d,.-]", "", raw)
    if not cleaned:
        return None

    if "," in cleaned and "." in cleaned:
        if cleaned.rfind(",") > cleaned.rfind("."):
            cleaned = cleaned.replace(".", "").replace(",", ".")
        else:
            cleaned = cleaned.replace(",", "")
    elif "," in cleaned:
        cleaned = cleaned.replace(".", "").replace(",", ".")
    elif re.fullmatch(r"[+-]?\d{1,3}(?:\.\d{3})+", cleaned):
        cleaned = cleaned.replace(".", "")

    try:
        return Decimal(cleaned).quantize(Decimal("0.01"))
    except InvalidOperation:
        return None


def iter_money(text: str, *, loose: bool = False) -> list[MoneyMatch]:
    matches: list[MoneyMatch] = []
    for match in MONEY_RE.finditer(text):
        raw = match.group(0).strip()
        amount = match.group("amount")
        has_currency = bool(match.group("prefix") or match.group("suffix"))
        has_decimal = bool(re.search(r"[,.]\d{2}$", amount))
        before = text[max(0, match.start() - 1) : match.start()]
        after = text[match.end() : match.end() + 1]
        if "%" in (before + after):
            continue
        if not (has_currency or has_decimal or loose):
            continue
        value = parse_money(raw)
        if value is not None:
            matches.append(MoneyMatch(value=value, raw=raw, start=match.start(), end=match.end()))
    return matches


def parse_date_match(match: re.Match[str]) -> tuple[str, str] | None:
    day = int(match.group("d"))
    month = int(match.group("m"))
    year = int(match.group("y"))
    if year < 100:
        year += 2000
    try:
        parsed = date(year, month, day)
    except ValueError:
        return None
    return parsed.isoformat(), match.group(0)


def find_date(text: str) -> tuple[str | None, str | None, str]:
    normalized = normalize_tr(text)
    candidates: list[tuple[int, str, str]] = []
    for pattern in DATE_PATTERNS:
        for match in pattern.finditer(text):
            parsed = parse_date_match(match)
            if not parsed:
                continue
            iso_value, raw = parsed
            window = normalized[max(0, match.start() - 80) : match.start()]
            score = 0 if any(label in window for label in DATE_LABELS) else 10
            candidates.append((score, iso_value, raw))
    if not candidates:
        return None, None, "none"
    score, iso_value, raw = sorted(candidates, key=lambda item: item[0])[0]
    return iso_value, raw, "high" if score == 0 else "medium"


def find_amount_by_labels(text: str, labels: list[str], *, exclude: Decimal | None = None) -> tuple[Decimal | None, str | None, str]:
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    for label in labels:
        for line in lines:
            normalized = normalize_tr(line)
            if label not in normalized:
                continue
            if label == "KDV" and any(skip in normalized for skip in ["KDV DAHIL", "KDV HARIC", "KDV ORANI"]):
                continue
            amounts = [item for item in iter_money(line, loose=True) if item.value != exclude]
            if amounts:
                selected = amounts[-1]
                return selected.value, selected.raw, "high"
    return None, None, "none"


def fallback_total(text: str) -> tuple[Decimal | None, str | None, str]:
    amounts = iter_money(text)
    if not amounts:
        return None, None, "none"
    selected = max(amounts, key=lambda item: item.value)
    return selected.value, selected.raw, "low"


def extract_invoice_fields(pdf_path: Path) -> dict[str, object]:
    text = extract_text(pdf_path)
    if not text.strip():
        return {"file": str(pdf_path), "error": "No extractable text found. OCR may be required."}

    invoice_date, invoice_date_raw, date_confidence = find_date(text)
    total, total_raw, total_confidence = find_amount_by_labels(text, TOTAL_LABELS)
    if total is None:
        total, total_raw, total_confidence = fallback_total(text)
    kdv, kdv_raw, kdv_confidence = find_amount_by_labels(text, KDV_LABELS, exclude=total)

    return {
        "file": str(pdf_path),
        "date": invoice_date,
        "date_raw": invoice_date_raw,
        "total": format(total, "f") if total is not None else None,
        "total_raw": total_raw,
        "kdv": format(kdv, "f") if kdv is not None else None,
        "kdv_raw": kdv_raw,
        "currency": "TRY",
        "confidence": {"date": date_confidence, "total": total_confidence, "kdv": kdv_confidence},
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Extract total, KDV, and date from Turkish PDF invoices.")
    parser.add_argument("pdf", nargs="+", type=Path, help="PDF invoice path(s)")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output")
    args = parser.parse_args()

    results = []
    for pdf_path in args.pdf:
        try:
            results.append(extract_invoice_fields(pdf_path))
        except Exception as exc:  # noqa: BLE001 - CLI should report per-file errors.
            results.append({"file": str(pdf_path), "error": str(exc)})

    output: object = results[0] if len(results) == 1 else results
    print(json.dumps(output, ensure_ascii=False, indent=2 if args.pretty else None))
    return 1 if any("error" in item for item in results) else 0


if __name__ == "__main__":
    raise SystemExit(main())
