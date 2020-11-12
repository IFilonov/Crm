import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from "vuex-persistedstate";

Vue.use(Vuex)

export default new Vuex.Store(  {
  state: {
    clients: [],
    companies: [],
    devices: [],
    juristic_types: [],
    client_companies: []
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
    },
    CHANGE_JURTYPES: (state, juristic_types) => {
      state.juristic_types  = juristic_types;
    },
    CHANGE_CLIENT_COMPANIES: (state, client_companies) => {
      state.client_companies  = client_companies;
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
    setCompanies: ( context, data ) => {
      context.commit('CHANGE_COMPANIES', data);
    },
    getDevices: ( context ) => {
      return Vue.prototype.$api.devices.index()
        .then(({ data }) => (context.commit('CHANGE_DEVICES', data)))
    },
    getJurTypes: ( context ) => {
      if (context.state.juristic_types.length == 0) {
        return Vue.prototype.$api.juristic_types.index()
          .then(({data}) => (context.commit('CHANGE_JURTYPES', data)))
      }
    },
    getClientCompanies: ( context ) => {
      return Vue.prototype.$api.client.companies()
        .then(({ data }) => (context.commit('CHANGE_CLIENT_COMPANIES', data)))
    }
  },
  modules: {},
  plugins: [createPersistedState()]
  }
)