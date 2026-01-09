'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('SessionSets', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      trainingSessionId: {
        type: Sequelize.UUID,
        references: { model: 'TrainingSessions', key: 'id' },
        onDelete: 'CASCADE'
      },
      exerciseId: {
        type: Sequelize.INTEGER,
        references: { model: 'Exercises', key: 'id' },
        onDelete: 'CASCADE'
      },
      set_number: Sequelize.INTEGER,
      reps: Sequelize.INTEGER,
      weight: Sequelize.FLOAT
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('SessionSets');
  }
};
