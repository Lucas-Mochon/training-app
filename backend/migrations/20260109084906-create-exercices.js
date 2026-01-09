'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Exercises', {
      id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true
      },
      name: { type: Sequelize.STRING, allowNull: false },
      description: { type: Sequelize.TEXT },
      difficulty: { type: Sequelize.ENUM('easy','medium','hard') },
      is_compound: { type: Sequelize.BOOLEAN, defaultValue: false },
      equipment: { type: Sequelize.ENUM('barbell','dumbbell','bodyweight','machine') },
      createdAt: { type: Sequelize.DATE, defaultValue: Sequelize.literal('NOW()') },
      updatedAt: { type: Sequelize.DATE, defaultValue: Sequelize.literal('NOW()') }
    });
  },

  async down(queryInterface) {
    await queryInterface.dropTable('Exercises');
    await queryInterface.sequelize.query('DROP TYPE IF EXISTS "enum_Exercises_difficulty";');
    await queryInterface.sequelize.query('DROP TYPE IF EXISTS "enum_Exercises_equipment";');
  }
};
