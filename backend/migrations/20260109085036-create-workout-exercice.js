'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('WorkoutExercises', {
      workoutId: {
        type: Sequelize.UUID,
        references: { model: 'Workouts', key: 'id' },
        onDelete: 'CASCADE',
        primaryKey: true
      },
      exerciseId: {
        type: Sequelize.INTEGER,
        references: { model: 'Exercises', key: 'id' },
        onDelete: 'CASCADE',
        primaryKey: true
      },
      sets: Sequelize.INTEGER,
      reps: Sequelize.STRING,
      rest_seconds: Sequelize.INTEGER,
      order_index: Sequelize.INTEGER
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('WorkoutExercises');
  }
};
