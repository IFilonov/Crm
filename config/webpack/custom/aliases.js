const path = require('path');

module.exports = {
  resolve: {
    alias: {
      functions$: path.resolve(process.cwd(), 'app/javascript/crm/utils/functions'),
      errors$: path.resolve(process.cwd(), 'app/javascript/crm/utils/errors'),
      validators$: path.resolve(process.cwd(), 'app/javascript/crm/utils/validators'),
      entity_loads$: path.resolve(process.cwd(), 'app/javascript/crm/mixins/entity_loads'),
      notifications$: path.resolve(process.cwd(), 'app/javascript/crm/mixins/notifications'),
    }
  }
}
