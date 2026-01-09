'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Users', {
      id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.literal('gen_random_uuid()'),
        primaryKey: true
      },
      email: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true
      },
      password_hash: {
        type: Sequelize.STRING,
        allowNull: false
      },
      level: {
        type: Sequelize.ENUM('beginner','intermediate','advanced'),
        allowNull: false
      },
      goal: {
        type: Sequelize.ENUM('strength','hypertrophy','cut'),
        allowNull: false
      },
      createdAt: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('NOW()')
      },
      updatedAt: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('NOW()')
      }
    });
  },

  async down(queryInterface) {
    await queryInterface.dropTable('Users');
    await queryInterface.sequelize.query('DROP TYPE IF EXISTS "enum_Users_level";');
    await queryInterface.sequelize.query('DROP TYPE IF EXISTS "enum_Users_goal";');
  }
};
