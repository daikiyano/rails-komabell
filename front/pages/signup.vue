<template>
    <section>
        <h1>会員登録</h1>
        <b-field label="苗字">
            <b-input v-model="first_name"></b-input>
        </b-field>
        <b-field label="Email"
            type="is-danger"
            message="適切なアドレスを入力してください">
            <b-input type="email"
                maxlength="30" v-model="email">
            </b-input>
        </b-field>
        <b-field label="Password">
            <b-input type="password"
                password-reveal>
            </b-input>
        </b-field>
    </section>
</template>

<script>

export default {
    data() {
        return {
            first_name : "",
            email : "",
            password : ""
        }
    }

}
</script>

