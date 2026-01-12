'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('WorkoutExercises', 'id', {
      type: Sequelize.INTEGER,
      allowNull: false,
      autoIncrement: true
    });

    await queryInterface.removeConstraint(
      'WorkoutExercises',
      'WorkoutExercises_pkey'
    );

    await queryInterface.addConstraint('WorkoutExercises', {
      fields: ['id'],
      type: 'primary key',
      name: 'WorkoutExercises_id_pkey'
    });

    await queryInterface.addConstraint('WorkoutExercises', {
      fields: ['workoutId', 'exerciseId'],
      type: 'unique',
      name: 'WorkoutExercises_workout_exercise_unique'
    });
  },

  async down(queryInterface) {
    await queryInterface.removeConstraint(
      'WorkoutExercises',
      'WorkoutExercises_workout_exercise_unique'
    );

    await queryInterface.removeConstraint(
      'WorkoutExercises',
      'WorkoutExercises_id_pkey'
    );

    await queryInterface.removeColumn('WorkoutExercises', 'id');

    await queryInterface.addConstraint('WorkoutExercises', {
      fields: ['workoutId', 'exerciseId'],
      type: 'primary key',
      name: 'WorkoutExercises_pkey'
    });
  }
};
