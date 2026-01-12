'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('SessionSets', 'createdAt', {
      type: Sequelize.DATE,
      allowNull: false,
      defaultValue: Sequelize.literal('NOW()')
    });

    await queryInterface.addColumn('SessionSets', 'updatedAt', {
      type: Sequelize.DATE,
      allowNull: false,
      defaultValue: Sequelize.literal('NOW()')
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('SessionSets', 'updatedAt');
    await queryInterface.removeColumn('SessionSets', 'createdAt');
  }
};
