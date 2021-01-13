import Vue from 'vue'
import axios from 'axios'

const token = document.head.querySelector('meta[name="csrf-token"]')
//axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content

const x_csrf_header = {
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    common: {
      'X-CSRF-TOKEN': token.content
    }
  }
}

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
    create: (client) => adapter.post('/clients/create', client,  x_csrf_header),
    update: (client) => adapter.patch('/clients/update', client,  x_csrf_header),
    reset: (id) => adapter.patch('/clients/reset', id,  x_csrf_header),
    delete: (clients) => adapter.post('/clients/delete', clients,  x_csrf_header),
    get: (id) => adapter.post('/clients/id', id,  x_csrf_header)
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
    create: (company) => adapter.post('/companies/create', company,  x_csrf_header),
    update: (company) => adapter.patch('/companies/update', company,  x_csrf_header),
    delete: (companies) => adapter.post('/companies/delete', companies,  x_csrf_header),
    client_companies: (client) => adapter.post( '/companies/client_companies', client,  x_csrf_header),
    clients: (company) => adapter.post('/companies/clients', company,  x_csrf_header),
    devices: (company) => adapter.post('/companies/devices', company,  x_csrf_header),
    rebind_refs_data: (data) => adapter.patch( '/companies/rebind_refs_data', data,  x_csrf_header)
  },
  juristic_types: {
    index: () => adapter.get( '/juristic_types')
  },
  client_companies: {
    rebind_companies: (companies) => adapter.patch('/clients_companies/rebind_companies_to_client', companies,  x_csrf_header)
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
    create: (client) => adapter.post('/devices/create', client, x_csrf_header),
    update: (client) => adapter.patch('/devices/update', client, x_csrf_header),
    delete: (clients) => adapter.post('/devices/delete', clients, x_csrf_header),
    get: (id) => adapter.post('/devices/id', id,  x_csrf_header)
  },
  fixer: {
    index: (query) => adapter.get( `http://data.fixer.io/api/latest?access_key=${FIXER_API_KEY}`, query)
  }
}

Vue.prototype.$api = api
