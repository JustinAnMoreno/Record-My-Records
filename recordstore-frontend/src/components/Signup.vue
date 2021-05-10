<template>
  <div class="">
    <div class="">
      <h3 class="">Sign Up</h3>
      <form @submit.prevent="signup">
        <div class="" v-if="error">{{ error }}</div>

        <div class="">
          <label for="email" class="">E-mail Address</label>
          <input type="email" v-model="email" class="" id="email" placeholder="example@email.com">
        </div>

        <div class="">
          <label for="password" class="">Password</label>
          <input type="password" v-model="password" class="" id="password" placeholder="Password">
        </div>

        <div class="mb-6">
          <label for="password_confirmation" class="">Confrim Password</label>
          <input type="password" v-model="password_confirmation" class="" id="password_confirmation" placeholder="Re-enter Password">
        </div>
        <button type="submit" class="">Sign Up</button>

        <div class=""><router-link to="/" class="">Sign In</router-link></div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signup',
  // model data
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: ''
    }
  },
  // checking if user is signed in
  created () {
    this.checkedSignedIn()
  },
  updated () {
    this.checkedSignedIn()
  },
  methods: {
    signup () {
      this.$http.plain.post('/signup', { email: this.email, password: this.password, password_confirmation: this.password_confirmation })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        // run failed sign in method
        this.signupFailed(response)
        return
      }

      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/records')
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkedSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/records')
      }
    }
  }
}
</script>
