import Vue from 'vue'
import axios from 'axios'

//const token = document.head.querySelector('meta[name="csrf-token"]')
//axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content

const DADATA_API_KEY = process.env.DADATA_API_KEY
const FIXER_API_KEY = process.env.FIXER_API_KEY

const adapter = axios.create({
  baseURL: process.env.API_BASE_URL,
  headers: {
    Accept: 'application/json'
  }
})

const api = {
  clients: {
    index: () => adapter.get('/clients'),
    info: () => adapter.get('/clients/info'),
    create: (client) => adapter.post('/clients/create', client),
    update: (client) => adapter.patch('/clients/update', client),
    reset: (id) => adapter.patch('/clients/reset', id),
    delete: (clients) => adapter.post('/clients/delete', clients),
    get: (id) => adapter.post('/clients/id', id)
  },
  client: {
    companies: () => adapter.get('/client/companies'),
    logout: '/clients/logout'
  },
  staff: {
    logout: '/staffs/logout',
    email: () => adapter.get('/staffs/email')
  },
  companies: {
    index: () => adapter.get('/companies'),
    count: () => adapter.get('/companies/count'),
    index_paginate: (page, per_page, filter_name) =>
      adapter.get('/companies/part?page='+ page +'&per_page=' + per_page +'&filter_name=' + filter_name),
    create: (company) => adapter.post('/companies/create', company),
    update: (company) => adapter.patch('/companies/update', company),
    delete: (companies) => adapter.post('/companies/delete', companies),
    client_companies: (client) => adapter.post( '/companies/client_companies', client),
    clients: (company) => adapter.post('/companies/clients', company),
    devices: (company) => adapter.post('/companies/devices', company),
    rebind_refs_data: (data) => adapter.patch( '/companies/rebind_refs_data', data)
  },
  juristic_types: {
    index: () => adapter.get( '/juristic_types')
  },
  client_companies: {
    rebind_companies: (companies) => adapter.patch('/clients_companies/rebind_companies_to_client', companies)
  },
  dadata: {
    index: (query) => adapter.post( 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/party', query,
      {
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': `Token ${DADATA_API_KEY}`
        }
      })
  },
  devices: {
    index: () => adapter.get('/devices'),
    create: (client) => adapter.post('/devices/create', client),
    update: (client) => adapter.patch('/devices/update', client),
    delete: (clients) => adapter.post('/devices/delete', clients),
    get: (id) => adapter.post('/devices/id', id)
  },
  fixer: {
    index: (query) => adapter.get( `http://data.fixer.io/api/latest?access_key=${FIXER_API_KEY}`, query,
      {
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      })
  }
}

Vue.prototype.$api = api
