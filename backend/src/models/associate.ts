import User from './user';
import Workout from './workout';
import TrainingSession from './trainingSession';
import SessionSet from './sessionSet';
import MuscleGroup from './muscleGroups';
import ExerciseMuscle from './exerciceMuscle';
import Exercise from './exercice';
import WorkoutExercise from './workoutExercice';

/* ============================
   User ↔ Workout (1 → N)
============================ */
User.hasMany(Workout, { foreignKey: 'userId' });
Workout.belongsTo(User, { foreignKey: 'userId' });

/* ============================
   Workout ↔ Exercise (N ↔ N)
============================ */
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

/* ============================
   Exercise ↔ MuscleGroup (N ↔ N)
============================ */
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

/* ============================
   Exercise ↔ ExerciseMuscle (1 → N)
   (accès à la table pivot si besoin)
============================ */
Exercise.hasMany(ExerciseMuscle, { foreignKey: 'exerciseId' });
ExerciseMuscle.belongsTo(Exercise, { foreignKey: 'exerciseId' });

/* ============================
   MuscleGroup ↔ ExerciseMuscle (1 → N)
============================ */
MuscleGroup.hasMany(ExerciseMuscle, { foreignKey: 'muscleGroupId' });
ExerciseMuscle.belongsTo(MuscleGroup, { foreignKey: 'muscleGroupId' });

/* ============================
   Workout ↔ TrainingSession (1 → N)
============================ */
Workout.hasMany(TrainingSession, { foreignKey: 'workoutId' });
TrainingSession.belongsTo(Workout, { foreignKey: 'workoutId' });

/* ============================
   User ↔ TrainingSession (1 → N)
============================ */
User.hasMany(TrainingSession, { foreignKey: 'userId' });
TrainingSession.belongsTo(User, { foreignKey: 'userId' });

/* ============================
   TrainingSession ↔ SessionSet (1 → N)
============================ */
TrainingSession.hasMany(SessionSet, { foreignKey: 'trainingSessionId' });
SessionSet.belongsTo(TrainingSession, { foreignKey: 'trainingSessionId' });

/* ============================
   Exercise ↔ SessionSet (1 → N)
============================ */
Exercise.hasMany(SessionSet, { foreignKey: 'exerciseId' });
SessionSet.belongsTo(Exercise, { foreignKey: 'exerciseId' });