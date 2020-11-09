import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store(  {
  state: {
    clients: [],
    companies: [],
    devices: []
  },
  mutations: {
    CHANGE_CLIENTS: (state, clients) => {
      state.clients  = clients;
    },
    CHANGE_COMPANIES: (state, companies) => {
        state.companies  = companies;
    },
    CHANGE_DEVICES: (state, devices) => {
      state.devices  = devices;
    }
  },
  actions: {
    getClients: ( context ) => {
      return Vue.prototype.$api.clients.index()
        .then(({ data }) => (context.commit('CHANGE_CLIENTS', data)))
    },
    getCompanies: ( context ) => {
      return Vue.prototype.$api.companies.index()
        .then(({ data }) => (context.commit('CHANGE_COMPANIES', data)))
    },
    getDevices: ( context ) => {
      return Vue.prototype.$api.devices.index()
        .then(({ data }) => (context.commit('CHANGE_DEVICES', data)))
    }
  },
  modules: {},
  plugins: []
  }
)