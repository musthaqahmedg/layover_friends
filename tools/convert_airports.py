import csv
import json
import os

INPUT_FILE = "airport-codes.csv"
OUTPUT_FILE = os.path.join("assets", "airports.json")

def clean(value):
    return (value or "").strip()

def main():
    airports = []
    seen = set()

    with open(INPUT_FILE, newline="", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)

        for row in reader:
            iata = clean(row.get("iata_code"))

            if len(iata) != 3 or not iata.isalpha():
                continue

            iata = iata.upper()

            if iata in seen:
                continue
            seen.add(iata)

            city = clean(row.get("municipality"))
            country_code = clean(row.get("iso_country")).upper()
            country_name = country_code  # we keep ISO code for now

            airports.append({
                "code": iata,
                "city": city,
                "country": country_name,
                "countryCode": country_code
            })

    os.makedirs("assets", exist_ok=True)

    with open(OUTPUT_FILE, "w", encoding="utf-8") as jsonfile:
        json.dump(airports, jsonfile, ensure_ascii=False)

    print(f"Converted {len(airports)} airports successfully.")

if __name__ == "__main__":
    main()
