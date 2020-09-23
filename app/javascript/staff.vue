<template>

  <div id="app">
    <navbar :user_email_path="this.user_email_path" :user_logout_path="this.user_logout_path"></navbar>
    <p>{{ message }}</p>
  </div>
</template>

<script>
import navbar from "./components/navbar";

export default {
  components: {
    'navbar': navbar
  },
  data: function () {
    return {
      message: "Hello Staff!",
      user_email_path: "/staffs/staff_email",
      user_logout_path: "/staffs/staff_logout"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
