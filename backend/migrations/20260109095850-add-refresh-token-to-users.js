'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Users', 'refreshToken', {
      type: Sequelize.STRING,
      allowNull: true,
      after: 'goal',
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('Users', 'refreshToken');
  }
};
