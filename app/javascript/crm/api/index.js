import Vue from 'vue'
import axios from 'axios'

const token = document.head.querySelector('meta[name="csrf-token"]')
axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content
const  DADATA_API_KEY = "e3c2ca1dd9c7c0c37b95a7b040f2116b17e5c418"

const adapter = axios.create({
    headers: {
        "Accept": "application/json"
    }
})

const api = {
    clients: {
        index: () => adapter.get("/clients"),
        email: () => adapter.get("/clients/client_email"),
        create: (client) => adapter.post("/clients/create", client),
        update: (client) => adapter.patch("/clients/update", client),
        reset: (id) => adapter.patch("/clients/reset", id),
        delete: (clients) => adapter.post("/clients/delete", clients),
        get: (id) => adapter.post("/clients/id", id)
    },
    client: {
        companies: () => adapter.get("/client/companies"),
        logout: "/clients/client_logout"
    },
    staff: {
        logout: "/staffs/staff_logout",
        email: () => adapter.get("/staffs/staff_email")
    },
    companies: {
        index: () => adapter.get( "/companies"),
        create: (company) => adapter.post("/companies/create", company),
        update: (company) => adapter.patch("/companies/update", company),
        delete: (companies) => adapter.post("/companies/delete", companies),
        client_companies: (client) => adapter.post( "/companies/client_companies", client),
        clients: (company) => adapter.post("/companies/clients", company)
    },
    juristic_types: {
        index: () => adapter.get( "/juristic_types")
    },
    client_companies: {
        rebind_companies: (companies) => adapter.patch("/clients_companies/rebind_companies_to_client", companies),
        rebind_clients: (clients) => adapter.patch( "/clients_companies/rebind_clients_to_company", clients)
    },
    dadata: {
        index: (query) => adapter.post( "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/party", query,
            {
                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Token " + DADATA_API_KEY
                }
            })
    }
}

Vue.prototype.$api = api
