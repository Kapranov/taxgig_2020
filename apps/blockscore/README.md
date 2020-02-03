# Blockscore

**TODO: Add description**

```
bash> mix new blockscore --sup

iex> Blockscore.get_status(
       "Cupertino", "US", "95014", "1 Infinite Loop", "Apt 6",
       "CA", 23, 8, 1993, "ssn", "0000", "John", "Doe", "Pearce"
     )

# output:
{:ok, "valid"}

bash> curl https://api.blockscore.com/people \
        -u sk_test_6596def12b6a0fba8784ce0bd381a8e6: \
        -header "Accept: application/vnd.blockscore+json;version=4" \
        -d 'name_first=John' \
        -d 'name_last=Doe' \
        -d 'document_type=ssn' \
        -d 'document_value=0000' \
        -d 'birth_day=23' \
        -d 'birth_month=8' \
        -d 'birth_year=1993' \
        -d 'address_street1=1 Infinite Loop' \
        -d 'address_city=Cupertino' \
        -d 'address_subdivision=CA' \
        -d 'address_postal_code=95014' \
        -d 'address_country_code=US' \
        | jq .

# output:
{
  "object": "person",
  "id": "5cae1c96323139000c00232c",
  "created_at": 1554914454,
  "updated_at": 1554914454,
  "status": "valid",
  "livemode": false,
  "phone_number": null,
  "ip_address": null,
  "birth_day": 23,
  "birth_month": 8,
  "birth_year": 1993,
  "name_first": "John",
  "name_middle": null,
  "name_last": "Doe",
  "address_street1": "1 Infinite Loop",
  "address_street2": null,
  "address_city": "Cupertino",
  "address_subdivision": "CA",
  "address_postal_code": "95014",
  "address_country_code": "US",
  "document_type": "ssn",
  "document_value": "0000",
  "note": null,
  "details": {
    "address": "no_match",
    "address_risk": "low",
    "identification": "no_match",
    "date_of_birth": "not_found",
    "ofac": "no_match",
    "pep": "no_match"
  },
  "question_sets": []
}
```

What qualifies as a good response?

If `"status": "valid"`, then the person is verified
If `"status": "invalid"`, then the person is denied with access.

He/she receives a pop-up to contact support and resolve the issue

### 3 Feb 2020 by Oleg G.Kapranov
