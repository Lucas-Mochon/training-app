'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('ExerciseMuscles', {
      exerciseId: {
        type: Sequelize.INTEGER,
        references: { model: 'Exercises', key: 'id' },
        onDelete: 'CASCADE',
        primaryKey: true
      },
      muscleGroupId: {
        type: Sequelize.INTEGER,
        references: { model: 'MuscleGroups', key: 'id' },
        onDelete: 'CASCADE',
        primaryKey: true
      },
      role: { type: Sequelize.ENUM('primary','secondary'), allowNull: false }
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('ExerciseMuscles');
    await queryInterface.sequelize.query('DROP TYPE IF EXISTS "enum_ExerciseMuscles_role";');
  }
};
