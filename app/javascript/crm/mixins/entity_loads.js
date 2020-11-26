export default {
  data () {
    return {
      loading: true,
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
      selected: []
    }
  }
}