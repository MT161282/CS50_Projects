-- ############################################################
-- FIFTYVILLE MYSTERY - COMPLETE INVESTIGATION LOG
-- Theft took place: July 28, 2025
-- Location: Humphrey Street
-- Goal: Find thief, escape city, and accomplice
-- ############################################################


-- ============================================================
-- STEP 1: Read the crime scene report for July 28, 2025
--         on Humphrey Street to get initial clues
-- ============================================================
SELECT description
  FROM crime_scene_reports
 WHERE year = 2025
   AND month = 7
   AND day = 28
   AND street = 'Humphrey Street';

-- NOTE FROM REPORT:
-- Theft happened at 10:15am at the Humphrey Street bakery.
-- Three witnesses were interviewed. Their interviews mention the bakery.


-- ============================================================
-- STEP 2: Read all three witness interviews from July 28, 2025
--         that mention the bakery (as the report hinted)
-- ============================================================
SELECT name, transcript
  FROM interviews
 WHERE year = 2025
   AND month = 7
   AND day = 28
   AND transcript LIKE '%bakery%';

-- NOTE FROM INTERVIEWS:
-- Ruth:    Thief got into a car in the bakery parking lot within 10 min after theft (before 10:25am)
-- Eugene:  Thief was at the ATM on Leggett Street withdrawing money earlier that morning
-- Raymond: Thief called someone for less than a minute. The accomplice will buy earliest flight
--          out of Fiftyville the NEXT DAY (July 29). Thief mentioned the phone call destination city.


-- ============================================================
-- STEP 3: Check bakery parking lot security logs
--         between 10:15am and 10:25am on July 28, 2025
--         (Ruth's clue - thief left within 10 minutes)
-- ============================================================
SELECT activity, license_plate, hour, minute
  FROM bakery_security_logs
 WHERE year = 2025
   AND month = 7
   AND day = 28
   AND hour = 10
   AND minute >= 15
   AND minute <= 25
   AND activity = 'exit';

-- NOTE: We now have a list of license plates that LEFT the bakery between 10:15 and 10:25


-- ============================================================
-- STEP 4: Check ATM transactions on Leggett Street
--         on July 28, 2025 (Eugene's clue - thief was withdrawing money)
-- ============================================================
SELECT account_number, amount
  FROM atm_transactions
 WHERE year = 2025
   AND month = 7
   AND day = 28
   AND atm_location = 'Leggett Street'
   AND transaction_type = 'withdraw';

-- NOTE: We now have account numbers of people who withdrew money at Leggett Street ATM


-- ============================================================
-- STEP 5: Find people who match BOTH the bakery parking lot
--         AND the ATM withdrawal clues
--         Cross-reference: people -> bank_accounts -> atm_transactions
--                          people -> bakery_security_logs
-- ============================================================
SELECT DISTINCT people.name, people.id, people.phone_number, people.passport_number, people.license_plate
  FROM people
  JOIN bank_accounts ON people.id = bank_accounts.person_id
  JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
  JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate
 WHERE atm_transactions.year = 2025
   AND atm_transactions.month = 7
   AND atm_transactions.day = 28
   AND atm_transactions.atm_location = 'Leggett Street'
   AND atm_transactions.transaction_type = 'withdraw'
   AND bakery_security_logs.year = 2025
   AND bakery_security_logs.month = 7
   AND bakery_security_logs.day = 28
   AND bakery_security_logs.hour = 10
   AND bakery_security_logs.minute >= 15
   AND bakery_security_logs.minute <= 25
   AND bakery_security_logs.activity = 'exit';

-- NOTE: This narrows down our suspects significantly


-- ============================================================
-- STEP 6: Check phone calls on July 28, 2025
--         less than 60 seconds (Raymond's clue)
--         Filter to only our suspects from Step 5
-- ============================================================
SELECT caller, receiver, duration
  FROM phone_calls
 WHERE year = 2025
   AND month = 7
   AND day = 28
   AND duration < 60
   AND caller IN (
       SELECT people.phone_number
         FROM people
         JOIN bank_accounts ON people.id = bank_accounts.person_id
         JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
         JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate
        WHERE atm_transactions.year = 2025
          AND atm_transactions.month = 7
          AND atm_transactions.day = 28
          AND atm_transactions.atm_location = 'Leggett Street'
          AND atm_transactions.transaction_type = 'withdraw'
          AND bakery_security_logs.year = 2025
          AND bakery_security_logs.month = 7
          AND bakery_security_logs.day = 28
          AND bakery_security_logs.hour = 10
          AND bakery_security_logs.minute >= 15
          AND bakery_security_logs.minute <= 25
          AND bakery_security_logs.activity = 'exit'
   );

-- NOTE: From the short calls, we can identify the thief's phone number
--       and the accomplice's phone number (the receiver)


-- ============================================================
-- STEP 7: Find all flights OUT of Fiftyville on July 29, 2025
--         (Raymond's clue - accomplice buys EARLIEST flight next day)
--         First, find Fiftyville's airport id
-- ============================================================
SELECT id, abbreviation, full_name, city
  FROM airports
 WHERE city = 'Fiftyville';

-- NOTE: We now know Fiftyville's airport ID (let's call it origin_airport_id)


-- ============================================================
-- STEP 8: Find the EARLIEST flight out of Fiftyville
--         on July 29, 2025
-- ============================================================
SELECT flights.id, flights.hour, flights.minute, airports.city AS destination_city
  FROM flights
  JOIN airports ON flights.destination_airport_id = airports.id
 WHERE flights.year = 2025
   AND flights.month = 7
   AND flights.day = 29
   AND flights.origin_airport_id = (
       SELECT id FROM airports WHERE city = 'Fiftyville'
   )
 ORDER BY flights.hour ASC, flights.minute ASC
 LIMIT 1;

-- NOTE: This gives us the ESCAPE CITY (destination of earliest flight)
--       and the flight id we need for passenger list


-- ============================================================
-- STEP 9: Find passengers on the earliest flight (July 29)
--         and cross-reference with our suspects from Step 5
--         This identifies THE THIEF
-- ============================================================
SELECT people.name, people.passport_number
  FROM people
  JOIN passengers ON people.passport_number = passengers.passport_number
 WHERE passengers.flight_id = (
       SELECT flights.id
         FROM flights
         JOIN airports ON flights.destination_airport_id = airports.id
        WHERE flights.year = 2025
          AND flights.month = 7
          AND flights.day = 29
          AND flights.origin_airport_id = (
              SELECT id FROM airports WHERE city = 'Fiftyville'
          )
        ORDER BY flights.hour ASC, flights.minute ASC
        LIMIT 1
   )
   AND people.name IN (
       SELECT people.name
         FROM people
         JOIN bank_accounts ON people.id = bank_accounts.person_id
         JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
         JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate
        WHERE atm_transactions.year = 2025
          AND atm_transactions.month = 7
          AND atm_transactions.day = 28
          AND atm_transactions.atm_location = 'Leggett Street'
          AND atm_transactions.transaction_type = 'withdraw'
          AND bakery_security_logs.year = 2025
          AND bakery_security_logs.month = 7
          AND bakery_security_logs.day = 28
          AND bakery_security_logs.hour = 10
          AND bakery_security_logs.minute >= 15
          AND bakery_security_logs.minute <= 25
          AND bakery_security_logs.activity = 'exit'
   );

-- NOTE: The person who appears in ALL clues is THE THIEF
-- ANSWER: The thief is Bruce


-- ============================================================
-- STEP 10: Find the ACCOMPLICE
--          The accomplice is the RECEIVER of the thief's short phone call
--          on July 28, 2025
-- ============================================================
SELECT people.name
  FROM people
 WHERE people.phone_number = (
       SELECT receiver
         FROM phone_calls
        WHERE year = 2025
          AND month = 7
          AND day = 28
          AND duration < 60
          AND caller = (
              SELECT phone_number
                FROM people
               WHERE name = 'Bruce'
          )
   );

-- NOTE: The accomplice is Robin


-- ============================================================
-- STEP 11: CONFIRM the escape city
--          (already found in Step 8, but let's be explicit)
-- ============================================================
SELECT airports.city AS escape_city
  FROM flights
  JOIN airports ON flights.destination_airport_id = airports.id
 WHERE flights.year = 2025
   AND flights.month = 7
   AND flights.day = 29
   AND flights.origin_airport_id = (
       SELECT id FROM airports WHERE city = 'Fiftyville'
   )
   AND flights.id IN (
       SELECT flight_id
         FROM passengers
        WHERE passport_number = (
              SELECT passport_number
                FROM people
               WHERE name = 'Bruce'
        )
   );

-- NOTE: The escape city is New York City


-- ============================================================
-- FINAL ANSWERS:
-- Thief:       Bruce
-- Escape City: New York City
-- Accomplice:  Robin
-- ============================================================
