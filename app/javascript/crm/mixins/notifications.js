export default {
  data () {
    return {
      errors: []
    }
  },
  methods: {
    showNotif (message) {
      this.$q.notify({
        message: message,
        color: 'purple'
      })
    },
    showErrNotif (args) {
      this.$q.notify({
        message: "Error! " + args.message,
        color: 'red'
      })
    }
  }
}