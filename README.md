# Anagramagic
This is an app that lets you experiment with anagrams (a word or phrase formed by rearranging the letters of a different word or phrase).
Below are a set of enpoints that can be utilized to do a variety of anagram-ish things. The database contains every word in the English dictionary, and there are also endpoints to add/delete words.

This app can be used two ways, either pulled down and ran locally, or by utilizing the existing Heroku app:

- ### Local Instructions
  - Clone down repo
  - Run `rake db:create db:migrate db:seed`
  - Grab a coffee (datebase seeding can take a few hours)
  - Start server with `rails s`
  - Utilize this URL (assuming you are are running server on default port)
    - `http://localhost:3000/api/vi`

- ### Live URL instructions
  - Utilize this URL:
    - `https://anagramagic.herokuapp.com/api/v1`

### Endpoints
  - **GET** `/anagrams/{ word }`
    - Get anagrams of a desired word
      - Required Params
        - none
      - Optional Params
        - `?limit={ integer }`
          - optional parameter to limit options of result
        - `?proper_nouns={ boolean }`
          - option parameter to show propert nouns in result
      - Successful Response
        - Body

          ```
          {
            "anagrams": [
                "ared",
                "daer",
                "dare",
                "dear"
            ]
          }
          ```
        - Status
          - `200`
      - Unsuccessful Response
        - Body

           `That word does not exist in the corpus`
        - Status
          - `404`

  - **GET** `/corpus-detail`
    - Get details of corpus
      - Required Params
        - none
      - Optional Params
        - none
      - Successful Response
        - Body
            ```
            {
              "Total Corpus Count": 235889,
              "Minimum Word Length": 1,
              "Maximum Word Length": 24,
              "Median Word Length": 9,
              "Average Word Length": 9.569
            }
            ```
        - Status
          - `200`
      - Unsuccessful Response
        - Body
          - none
        - Status
          - none

  - **GET** `anagrams-list/{ integer }`
    - Get all anagrams with a count greater than or equal to provided integer
      - Required Params
        - none
      - Optional Params
        - none
      - Successful Response
        - Body
          ```
          [
            [
                "Canari",
                "Carian",
                "Crania",
                "acinar",
                "arnica",
                "canari",
                "carina",
                "crania",
                "narica"
            ],
            [
                "Caroline",
                "Cornelia",
                "Lonicera",
                "acrolein",
                "arecolin",
                "caroline",
                "colinear",
                "creolian"
            ]
          ]
          ```
        - Status
          - `200`
      - Unsuccessful Response
        - Body

          `There are no angrams of that length, check your integer`
        - Status
          - `404`

  - **GET** `/big-ol-anagram`
    - Get the largest anagram in the corpus
      - Required Params
        - none
      - Optional Params
        - none
      - Successful Response
        - Body
          ```
          [
            "Orang",
            "Ronga",
            "angor",
            "argon",
            "goran",
            "grano",
            "groan",
            "nagor",
            "orang",
            "organ",
            "rogan"
          ]
          ```
        - Status
          - `200`
      - Unsuccessful Response
        - Body
          - none
        - Status
          - none

  - **POST** `/anagrams`
    - Post additional words to the corpus. Can be a single or multiple word array.
      - Required Params
        - `{ "words": ["wordx", "wordz"] }`
      - Optional Params
        - none
      - Successful Response
        - Body
          ```
          [
            {
              "anagrams":[]
            },
            {
              "anagrams":[]
            }
          ]
          ```
        - Status
          - `201`
      - Unsuccessful Response
        - Body
          - none
         - Status
          - `204`

  - **DELETE** `/anagrams/{ word }`
    - Delete single word from corpus
      - Required Params
        - none
      - Optional Params
        - none
      - Successful Response
        - Body
          - empty
        - Status
          - `204`
      - Unsuccessful Response
        - Body
          - `That word does not exist in the corpus`
        - Status
          - 404
  - **DELETE** `/anagrams/{ word }/destroy_anagram`
    - Delete word an all its anagrams from corpus
      - Required Params
        - none
      - Optional Params
        - none
      - Successful Response
        - Body
          - empty
        - Status
          - `204`
      - Unsuccessful Response
        - Body
          - `That word does not exist in the corpus`
        - Status
          - 404
  - **DELETE** `/destroy-all-anagrams`
    - Delete _ENTIRE CORPUS. PLEASE BE CAREFUL_
      - Required Params
        - none
      - Optional Params
        - none
      - Successful Response
        - Body
          - empty
        - Status
          - `204`
      - Unsuccessful Response
        - Body
          - none
        - Status
          - none

## Development Notes
- I started with a SQLite database, but switched to Postgresql once I decided I would host the app on Heroku.
- I decided to create additional attributes when seeding the database, which made the initial database creation slow, but the requests more efficient.
- It seemed odd to make a `destroy-all` request, not sure how a user would use it, and it could cause a lot of damage. It also seems like something that should have a confirmation, so thats why I made the endpoint URL so descriptive.
- Included plain text error messages where applicable. Detailed error messages are better error messages.

**v2 Considerations**
  - Because this lives online, it should have a authentication system in place.
  - There are a few endpoints that would definitely benefit from caching, like `/big-ol-anagram` and `/corpus-detail` for example.
