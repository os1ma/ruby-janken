CREATE TABLE "players" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "name" varchar NOT NULL
);

CREATE TABLE "jankens" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "played_at" timestamp NOT NULL
);

CREATE TABLE "janken_details" (
  "id" SERIAL PRIMARY KEY NOT NULL,
  "janken_id" int NOT NULL,
  "player_id" int NOT NULL,
  "hand" int NOT NULL,
  "result" int NOT NULL
);

ALTER TABLE "janken_details" ADD FOREIGN KEY ("janken_id") REFERENCES "jankens" ("id");

ALTER TABLE "janken_details" ADD FOREIGN KEY ("player_id") REFERENCES "players" ("id");
