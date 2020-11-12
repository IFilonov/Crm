import Vue from 'vue'
import ActionCableVue from 'actioncable-vue'
import store from '../store'

Vue.use(ActionCableVue, {
  debug: true,
  debugLevel: 'error',
  connectImmediately: true,
  store
});
