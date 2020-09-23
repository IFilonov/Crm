<template>
  <div>
    <b-navbar toggleable="lg" type="dark" variant="info">
      <b-navbar-brand href="#">NavBar</b-navbar-brand>

      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav>
          <img src="https://placekitten.com/g/30/30" alt="Kitten">
        </b-navbar-nav>

        <!-- Right aligned nav items -->
        <b-navbar-nav class="ml-auto">
          <b-nav-item-dropdown right>
            <!-- Using 'button-content' slot -->
            <template v-slot:button-content>
              <em> Hello, {{ staff_email }}</em>
            </template>
            <b-dropdown-item :href="this.user_logout_path">Sign Out</b-dropdown-item>
          </b-nav-item-dropdown>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      staff_email: null
     }
  },
  props: ['user_email_path', 'user_logout_path'],
  methods: {
    async fetchCurrentStaff () {
      const response = await this.$api.get(this.user_email_path);
      this.staff_email = response.data.staff_email;
    }
  },
  mounted() {
    this.fetchCurrentStaff();
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
