'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Workouts', {
      id: { type: Sequelize.UUID, defaultValue: Sequelize.literal('gen_random_uuid()'), primaryKey: true },
      userId: {
        type: Sequelize.UUID,
        references: { model: 'Users', key: 'id' },
        onDelete: 'CASCADE'
      },
      goal: { type: Sequelize.ENUM('strength','hypertrophy','cut'), allowNull: false },
      duration: { type: Sequelize.INTEGER, allowNull: false },
      createdAt: { type: Sequelize.DATE, defaultValue: Sequelize.literal('NOW()') },
      updatedAt: { type: Sequelize.DATE, defaultValue: Sequelize.literal('NOW()') }
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('Workouts');
    await queryInterface.sequelize.query('DROP TYPE IF EXISTS "enum_Workouts_goal";');
  }
};
