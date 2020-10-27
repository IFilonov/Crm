export default {
  data () {
    return {
      client: {
        fullname: '',
        email: '',
        phone: ''
      },
      company: {
        id: '',
        name: '',
        inn: '',
        juristic_type_id: '',
        ogrn: ''
      },
      device: {
        name: '',
        type: '',
        serial: '',
        company_id: ''
      },
      clients: [],
      companies: [],
      devices: [],
      errors: []
    }
  },
  methods: {
    async getClients() {
      try {
        const response = await this.$api.clients.index();
        this.clients = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getDevices() {
      try {
        const response = await this.$api.devices.index();
        this.devices = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getCompanies() {
      try {
        const response = await this.$api.companies.index();
        this.companies = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    }
  }
}