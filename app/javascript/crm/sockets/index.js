import Vue from 'vue'
//import ActionCable from 'actioncable'
//const cable = ActionCable.createConsumer()
//import actionCablePlugin from './action-cable-plugin'

//Vue.use(actionCablePlugin, cable)
import ActionCableVue from 'actioncable-vue'

Vue.use(ActionCableVue, {
  debug: true,
  debugLevel: 'error',
  //connectionUrl: 'ws://localhost:3000/api/cable', // or function which returns a string with your JWT appended to your server URL as a query parameter
  connectImmediately: true,
});