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
        juristic_type_id: '',
        jur_type: '',
        inn: '',
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