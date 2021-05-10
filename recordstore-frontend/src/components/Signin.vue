<template>
  <div class="">
    <div class="">
      <h3 class="">Sign In</h3>
      <form @submit.prevent="signin">
        <div class="" v-if="error">{{ error }}</div>

        <div class="">
          <label for="email" class="">E-mail Address</label>
          <input type="email" v-model="email" class="" id="email" placeholder="example@email.com">
        </div>
        <div class="">
          <label for="password" class="">Password</label>
          <input type="password" v-model="password" class="" id="password" placeholder="Password">
        </div>
        <button type="submit" class="">Sign In</button>

        <div class=""><router-link to="/signup" class="">Sign up</router-link></div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signin',
  // model data
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  // checking if user is signed in
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signin () {
      this.$http.plain.post('/signin',
        { email: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.csrf) {
        // run failed sign in method
        this.signinFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/records')
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/records')
      }
    }
  }
}
</script>

<style scoped>
</style>
