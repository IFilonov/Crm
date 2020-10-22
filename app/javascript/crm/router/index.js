import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import dashboard from "../components/staff/dashboard";

export default new VueRouter( {
  mode: 'history',
  routers: [
    { path: '/', component: dashboard}
  ]

})