import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import Clients from "../components/staff/clients";
import Companies from "../components/staff/companies";
import Client_edit from "../components/staff/client_edit";

export default new VueRouter( {
  mode: 'history',
  hashbang: false,
  routes: [
    { path: '/', redirect: '/staffs/clients'},
    {
      path: '/staffs/clients', component: Clients, name: 'Clients',
      children: [
        { path: ':id', component: Client_edit, name: 'Client_edit' }
      ]
    },
    { path: '/staffs/companies', component: Companies, name: 'Companies'}
  ]
})