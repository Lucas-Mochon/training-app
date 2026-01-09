const User = require('./models/User');
const Exercise = require('./models/Exercise');
const MuscleGroup = require('./models/MuscleGroup');
const ExerciseMuscle = require('./models/ExerciseMuscle');
const Workout = require('./models/Workout');
const WorkoutExercise = require('./models/WorkoutExercise');
const TrainingSession = require('./models/TrainingSession');
const SessionSet = require('./models/SessionSet');

User.hasMany(Workout);
Workout.belongsTo(User);

Exercise.belongsToMany(MuscleGroup, { through: ExerciseMuscle });
MuscleGroup.belongsToMany(Exercise, { through: ExerciseMuscle });

Workout.belongsToMany(Exercise, { through: WorkoutExercise });
Exercise.belongsToMany(Workout, { through: WorkoutExercise });

Workout.hasMany(TrainingSession);
TrainingSession.belongsTo(Workout);
User.hasMany(TrainingSession);
TrainingSession.belongsTo(User);

TrainingSession.hasMany(SessionSet);
SessionSet.belongsTo(TrainingSession);
Exercise.hasMany(SessionSet);
SessionSet.belongsTo(Exercise);
