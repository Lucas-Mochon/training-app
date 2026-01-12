'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('ExerciseMuscles', 'id', {
      type: Sequelize.INTEGER,
      allowNull: false,
      autoIncrement: true,
    });

    await queryInterface.removeConstraint(
      'ExerciseMuscles',
      'ExerciseMuscles_pkey'
    );

    await queryInterface.addConstraint('ExerciseMuscles', {
      fields: ['id'],
      type: 'primary key',
      name: 'ExerciseMuscles_id_pkey'
    });

    await queryInterface.addConstraint('ExerciseMuscles', {
      fields: ['exerciseId', 'muscleGroupId'],
      type: 'unique',
      name: 'ExerciseMuscles_exercise_muscle_unique'
    });
  },

  async down(queryInterface) {
    await queryInterface.removeConstraint(
      'ExerciseMuscles',
      'ExerciseMuscles_exercise_muscle_unique'
    );

    await queryInterface.removeConstraint(
      'ExerciseMuscles',
      'ExerciseMuscles_id_pkey'
    );

    await queryInterface.removeColumn('ExerciseMuscles', 'id');

    await queryInterface.addConstraint('ExerciseMuscles', {
      fields: ['exerciseId', 'muscleGroupId'],
      type: 'primary key',
      name: 'ExerciseMuscles_pkey'
    });
  }
};
