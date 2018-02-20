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
  - **GET** `/anagram-compare`
    - Get comparison of whether two provided words are anagrams of each other. Must be exactly two words.
      - Required Params
        - `word={word1, word2}`
      - Optional Params
        - none
  - **GET** `/corpus-detail`
    - Get details of corpus
      - Required Params
        - none
      - Optional Params
        - none
  - **GET** `anagrams-list/{ integer }`
    - Get all anagrams with a count greater than or equal to provided integer
      - Required Params
        - none
      - Optional Params
        - none
  - **GET** `/big-ol-anagram`
    - Get the largest anagram in the corpus
      - Required Params
        - none
      - Optional Params
        - none
  - **POST** `/anagrams`
    - Post additional words to the corpus. Can be a single or multiple word array.
      - Required Params
        - `word={word1, word2}`
      - Optional Params
        - none
  - **DELETE** `/anagrams/{ word }`
    - Delete single word from corpus
      - Required Params
        - none
      - Optional Params
        - none
  - **DELETE** `/anagrams/{ word }/destroy_anagram`
    - Delete word an all its angrams from corpus
      - Required Params
        - none
      - Optional Params
        - none
  - **DELETE** `/destroy-all-anagrams`
    - Delete _ENTIRE CORPUS. PLEASE BE CAREFUL_
      - Required Params
        - none
      - Optional Params
        - none

## Development Notes
- I started with a SQLite database, but switched to Postgresql once I decided I would host the app on Heroku.
- I decided to create additional attributes when seeding the database, which made the initial database creation slow, but the requests more efficient.
- It seemed odd to make a `destroy-all` request, not sure how a user would use it, and it could cause a lot of damage. It also seems like something that should have a confirmation, so thats why I made the endpoint URL so descriptive.
