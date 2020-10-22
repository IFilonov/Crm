import Vue from 'vue'
import axios from 'axios'

const token = document.head.querySelector('meta[name="csrf-token"]')
axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content
const  DADATA_API_KEY = "e3c2ca1dd9c7c0c37b95a7b040f2116b17e5c418"

const api = {
    clients: {
        index: () => axios.get("/clients"),
        email: () => axios.get("/clients/client_email"),
        create: (client) => axios.post("/clients/create", client),
        update: (client) => axios.patch("/clients/update", client),
        delete: (clients) => axios.post("/clients/delete", clients)
    },
    client: {
        companies: () => axios.get("/client/companies"),
        logout: "/clients/client_logout"
    },
    staff: {
        logout: "/staffs/staff_logout",
        email: () => axios.get("/staffs/staff_email")
    },
    companies: {
        index: () => axios.get( "/companies"),
        create: (company) => axios.post("/companies/create", company),
        update: (company) => axios.patch("/companies/update", company),
        delete: (companies) => axios.post("/companies/delete", companies),
        client_companies: (client) => axios.post( "/companies/client_companies", client),
        clients: (company) => axios.post("/companies/clients", company)
    },
    juristic_types: {
        index: () => axios.get( "/juristic_types")
    },
    client_companies: {
        rebind_companies: (companies) => axios.patch("/clients_companies/rebind_companies_to_client", companies),
        rebind_clients: (clients) => axios.patch( "/clients_companies/rebind_clients_to_company", clients)
    },
    dadata: {
        index: (query) => axios.post( "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/party", query,
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
