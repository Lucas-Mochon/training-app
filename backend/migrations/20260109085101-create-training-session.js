'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('TrainingSessions', {
      id: { type: Sequelize.UUID, defaultValue: Sequelize.literal('gen_random_uuid()'), primaryKey: true },
      workoutId: {
        type: Sequelize.UUID,
        references: { model: 'Workouts', key: 'id' },
        onDelete: 'CASCADE'
      },
      userId: {
        type: Sequelize.UUID,
        references: { model: 'Users', key: 'id' },
        onDelete: 'CASCADE'
      },
      performed_at: { type: Sequelize.DATE, defaultValue: Sequelize.literal('NOW()') },
      duration: Sequelize.INTEGER,
      feeling: { type: Sequelize.INTEGER, validate: { min: 1, max: 5 } }
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('TrainingSessions');
  }
};
