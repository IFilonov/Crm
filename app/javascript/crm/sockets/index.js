import Vue from 'vue'
import ActionCableVue from 'actioncable-vue'
import store from '../store'

Vue.use(ActionCableVue, {
  debug: true,
  // eslint-disable-next-line no-undef
  debugLevel: process.env.SOCKETS_DEBUG_LEVEL,
  connectImmediately: true,
  store
});
