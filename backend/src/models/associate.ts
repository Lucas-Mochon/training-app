import User from './user';
import Workout from './workout';

import TrainingSession from './trainingSession';
import SessionSet from './sessionSet';
import MuscleGroup from './muscleGroups';
import ExerciseMuscle from './exerciceMuscle';
import Exercise from './exercice';
import WorkoutExercise from './workoutExercice';

// === User ↔ Workout ===
User.hasMany(Workout, { foreignKey: 'userId' });
Workout.belongsTo(User, { foreignKey: 'userId' });

// === Workout ↔ Exercise (many-to-many) ===
Workout.belongsToMany(Exercise, {
  through: WorkoutExercise,
  as: 'exercises',
  foreignKey: 'workoutId',
  otherKey: 'exerciseId',
});

Exercise.belongsToMany(Workout, {
  through: WorkoutExercise,
  as: 'workouts',
  foreignKey: 'exerciseId',
  otherKey: 'workoutId',
});


// === Exercise ↔ MuscleGroup (many-to-many) ===
Exercise.belongsToMany(MuscleGroup, {
  through: ExerciseMuscle,
  as: 'muscleGroups',
  foreignKey: 'exerciseId',
  otherKey: 'muscleGroupId',
});

MuscleGroup.belongsToMany(Exercise, {
  through: ExerciseMuscle,
  as: 'exercises',
  foreignKey: 'muscleGroupId',
  otherKey: 'exerciseId',
});

// === Exercise ↔ ExerciseMuscle (belong-to-many) ===
Exercise.belongsToMany(ExerciseMuscle, {
  through: ExerciseMuscle,
  as: 'exerciseMuscles',
  foreignKey: 'exerciseId',
  otherKey: 'id',
});

ExerciseMuscle.belongsToMany(Exercise, {
  through: ExerciseMuscle,
  as: 'exercises',
  foreignKey: 'id',
  otherKey: 'exerciseId',
});

// === MuscleGroup ↔ ExerciseMuscle (belong-to-many) ===
MuscleGroup.belongsToMany(ExerciseMuscle, {
  through: ExerciseMuscle,
  as: 'exerciseMuscles',
  foreignKey: 'muscleGroupId',
  otherKey: 'id',
});

ExerciseMuscle.belongsToMany(MuscleGroup, {
  through: ExerciseMuscle,
  as: 'muscleGroups',
  foreignKey: 'id',
  otherKey: 'muscleGroupId',
});

// === Workout ↔ TrainingSession (one-to-many) ===
Workout.hasMany(TrainingSession, { foreignKey: 'workoutId' });
TrainingSession.belongsTo(Workout, { foreignKey: 'workoutId' });

// === User ↔ TrainingSession (one-to-many) ===
User.hasMany(TrainingSession, { foreignKey: 'userId' });
TrainingSession.belongsTo(User, { foreignKey: 'userId' });

// === TrainingSession ↔ SessionSet (one-to-many) ===
TrainingSession.hasMany(SessionSet, { foreignKey: 'trainingSessionId' });
SessionSet.belongsTo(TrainingSession, { foreignKey: 'trainingSessionId' });

// === Exercise ↔ SessionSet (one-to-many) ===
Exercise.hasMany(SessionSet, { foreignKey: 'exerciseId' });
SessionSet.belongsTo(Exercise, { foreignKey: 'exerciseId' });

