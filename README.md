# Anagramagic
This is an app that lets you experiment with anagrams (a word or phrase formed by rearranging the letters of a different word or phrase).
Below are a set of enpoints that can be utilized to do a variety of anagram-ish things. The database contains every word in the English dictionary, and there are also endpoints to add words.

This app can be used two ways, either pulled down and ran locally, or by utilizing the existing Heroku app:

- local URL (default Rails server) `http://localhost:3000/api/vi`
- live URL `https://anagramagic.herokuapp.com/api/v1`

### Endpoints
  - **GET** `/anagrams/{word}`
    - Get anagrams of a desired word
      - Required Params
        - none
      - Optional Params
        - `?limit={ integer }`
          - optional parameter to limit options of result
        - `?proper_nouns={ boolean }`
          - option parameter to show propert nouns in result
      - Response Body

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

  - **GET** `/anagram-compare`
    - Get comparison of whether two provided words are anagrams of each other. Must be exactly two words.
      - Required Params
        - `word={word1, word2}`
      - Optional Params
        - none
      - Response Body
        - `true`/`false`
      - Status
        - `200`
  - **GET** `/corpus-detail`
    - Get details of corpus
      - Required Params
        - none
      - Optional Params
        - none
      - Response Body
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
  - **GET** `anagrams-list/{ integer }`
    - Get all anagrams with a count greater than or equal to provided integer
      - Required Params
        - none
      - Optional Params
        - none
      - Response Body
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

  - **GET** `/big-ol-anagram`
    - Get the largest anagram in the corpus
      - Required Params
        - none
      - Optional Params
        - none
      - Response Body
        ```
        {
          "Total Corpus Count": 235888,
          "Minimum Word Length": 1,
          "Maximum Word Length": 24,
          "Median Word Length": 9,
          "Average Word Length": 9.569
        }
        ```
        - Status
          - `200`
  - **POST** `/anagrams`
    - Post additional words to the corpus. Can be a single or multiple word array.
      - Required Params
        - `word={word1, word2}`
      - Optional Params
        - none
      - Response Body
        ```
        [
          {
              "id": 235889,
              "word": "testx",
              "sorted_word": "esttx",
              "created_at": "2018-02-20T02:54:28.304Z",
              "updated_at": "2018-02-20T02:54:28.304Z",
              "word_length": 4,
              "proper_noun": false
          },
          {
              "id": 235890,
              "word": "testz",
              "sorted_word": "esttz",
              "created_at": "2018-02-20T02:54:28.456Z",
              "updated_at": "2018-02-20T02:54:28.456Z",
              "word_length": 4,
              "proper_noun": false
          }
        ]
        ```
      - Status
        - `201`
  - **DELETE** `/anagrams/{ word }`
    - Delete single word from corpus
      - Required Params
        - none
      - Optional Params
        - none
      - Response Body
        - empty
      - Status
        - `204`
  - **DELETE** `/anagrams/{ word }/destroy_anagram`
    - Delete word an all its anagrams from corpus
      - Required Params
        - none
      - Optional Params
        - none
      - Response Body
        - empty
      - Status
        - `204`
  - **DELETE** `/destroy-all-anagrams`
    - Delete _ENTIRE CORPUS. PLEASE BE CAREFUL_
      - Required Params
        - none
      - Optional Params
        - none
      - Response Body
        - empty
      - Status
        - `204`

## Development Notes
- I started with a SQLite database, but switched to Postgresql once I decided I would host the app on Heroku.
- I decided to create additional attributes when seeding the database, which made the initial database creation slow, but the requests more efficient.
- It seemed odd to make a `destroy-all` request, not sure how a user would use it, and it could cause a lot of damage. It also seems like something that should have a confirmation, so thats why I made the endpoint URL so descriptive.
