import 'package:powersync/powersync.dart';

const schema = Schema([
  Table('periodizations', [
    Column.text('name'),
    Column.text('acronym'),
    Column.text('description'),
    Column.text('createdAt'),
    Column.text('updatedAt'),
  ]),
  Table('weeks', [
    Column.text('periodizationId'),
    Column.text('title'),
    Column.text('subtitle'),
    Column.text('createdAt'),
    Column.text('updatedAt'),
  ]),
  Table('days', [
    Column.text('weeksId'),
    Column.text('title'),
    Column.text('subtitle'),
    Column.text('createdAt'),
    Column.text('updatedAt'),
  ]),
  Table('workouts', [
    Column.text('title'),
    Column.text('description'),
    Column.text('videoUrl'),
    Column.text('thumbnailUrl'),
    Column.text('createdAt'),
    Column.text('updatedAt'),
    Column.text('daysId')
  ]),
  Table('workout_parameters', [
    Column.text('workoutId'),
    Column.text('name'),
    Column.text('value'),
    Column.text('createdAt'),
    Column.text('updatedAt'),
  ]),
  Table('athletes', [
    Column.text('createdAt'),
    Column.text('updatedAt'),
    Column.text('firstName'),
    Column.text('lastName'),
    Column.text('gender'),
    Column.real('weight'),
    Column.real('height'),
    Column.text('city'),
    Column.text('address'),
    Column.text('birthday'),
    Column.integer('age'),
    Column.text('userId')
  ]),
  Table('category', [
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('name'),
    Column.text('userId'),
  ]),
  Table('personal_records', [
    Column.text('title'),
    Column.text('createdAt'),
    Column.text('updatedAt'),
    Column.text('userId'),
  ]),
  Table('personal_records_history', [
    Column.text('prId'),
    Column.real('weight'),
    Column.text('createdAt'),
    Column.text('userId'),
  ]),
  Table('user_workouts', [
    Column.text('userId'),
    Column.text('workoutId'),
    Column.text('playedAt'),
    Column.text('updatedAt'),
    Column.text('createdAt'),
  ]),
  Table('subscriptions', [
    Column.real('price'),
    Column.text('duration'),
    Column.text('dateSubscribed'),
    Column.text('dateExpired'),
    Column.integer('isSubscribed'),
    Column.text('userId'),
  ])
]);
