<template>
  <div>
    <h1>My Edit</h1>
    <MyPageTab :activeTab="activeTab" />
    <section>
      <ValidationObserver ref="observer" v-slot="{ passes }">
        <EmailInput v-model="form.email" disabled />
        <InputWithValidation
          rules="required|max:25"
          icon="account"
          label="ユーザー名"
          placeholder="ユーザー名"
          vid="password"
          v-model="form.username"
        />

        <BSelectWithValidation
          label="年齢"
          v-model="form.gender"
          placeholder="年齢を選択してください"
        >
          <!-- <option value=0>性別を選択してください</option> -->

          <option value>年齢を選択してください</option>
          <option v-for="i in 80" :key="i" :value="i">{{ i }}</option>
        </BSelectWithValidation>

        <BSelectWithValidation
          label="性別"
          v-model="form.gender"
          placeholder="性別を選択してください"
        >
          <!-- <option value=0>性別を選択してください</option> -->
          <option value>性別を選択してください</option>
          <option value="1">男性</option>
          <option value="2">女性</option>
          <option value="3">その他</option>
        </BSelectWithValidation>
        <InputWithValidation
          rules="max:200"
          label="自己紹介"
          type="textarea"
          vid="description"
          v-model="form.description"
        />
        <b-icon pack="fas" icon="tachometer-alt"> </b-icon>
        <InputWithValidation
          rules="max:25"
          icon="twitter"
          placeholder="Twitter id"
          vid="password"
          v-model="form.twitter_id"
        />
        <InputWithValidation
          icon="facebook"
          placeholder="Facebook id"
          rules="max:25"
          vid="facebook"
          v-model="form.facebook_id"
        />

        <InputWithValidation
          placeholder="wantedly id"
          rules="max:25"
          vid="wantedly"
          v-model="form.wantedly_id"
        />

        <InputWithValidation
          placeholder="GitHub id"
          icon="github"
          rules="max:25"
          vid="github"
          v-model="form.github_id"
        />
      </ValidationObserver>
    </section>
    <div v-for="(ValidationError, index) in this.ValidationErrors" :key="index">
      <span style="color: red">{{ ValidationError }}</span>
    </div>

    <button class="button" type="is-dark" @click="UpdateUser">更新</button>
    <!-- {{filteredTags}} -->
  </div>
</template>
<script>
import MyPageTab from "~/components/users/MyPageTab.vue";
import EmailInput from "~/components/Form/EmailInput.vue";
import { ValidationObserver, ValidationProvider } from "vee-validate";
import InputWithValidation from "~/components/Form/InputWithValidation.vue";
import BSelectWithValidation from "~/components/Form/BSelectWithValidation.vue";
import ImageUploadWithValidation from "~/components/Form/ImageUploadWithValidation.vue";
import * as firebase from "@/plugins/firebase";

export default {
  // middleware: 'auth',
  components: {
    MyPageTab,
    EmailInput,
    ValidationObserver,
    ValidationProvider,
    InputWithValidation,
    BSelectWithValidation,
  },
  data() {
    return {
      user: "",
      isModalForm: false,
      FormComponent: "",
      form: {
        email: "",
        username: "",
        gender: "",
        age: new Date(),
        birth: "",
        description: "",
        twitter_id: "",
        facebook_id: "",
        wantedly_id: "",
        github_id: "",
      },
      filteredTags: [],
      data: [],
      showWeekNumber: false,
      activeTab: 1,
      count: 0,
      ValidationErrors: [],
      jwt: null,
    };
  },
  created() {
    let self = this;
    firebase.auth().onAuthStateChanged((user) => {
      //ログインユーザーのfirebase情報をトークン形式で取得する
      if (user) {
        user.getIdToken().then(function (data) {
          console.log("data", data);
          self.jwt = data;
          self.fetchUser();
        });
      } else {
        console.log("mounted");
        // User is signed out
        // ...
      }
    });
  },

  methods: {
    UploadImage(image) {
      this.$axios.defaults.headers.common[
        "Authorization"
      ] = `Bearer ${this.jwt}`;
      var formData = new FormData();
      formData.append("user[image]", this.form.file);

      if (this.form.file) {
        this.$axios
          .$put("/api/v1/mypage/user_images", formData, {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          })
          .then((response) => {
            this.$buefy.toast.open({
              duration: 5000,
              message: "画像アップロードが完了しました",
              type: "is-success",
            });
            this.$router.push("/users/edit");
            console.log(response);
          })
          .catch((error) => {
            if (
              error.response.status == "401" ||
              error.response.status == "500" ||
              error.response.status == "422"
            ) {
              console.log("tokenが無効です");
              // this.error = "Tokenが無効です"
              this.$buefy.toast.open({
                duration: 5000,
                message: "サーバー内で問題が発生しました",
                type: "is-danger",
              });
            }
          });
      }
    },
    async fetchUser() {
      await this.$axios
        .$get("/api/v1/auto_login", {
          headers: {
            Authorization: `Bearer ${this.jwt}`,
          },
        })
        .then((response) => {
          console.log(response);
          this.form.username = response.username;
          this.form.email = response.email;
          this.form.age = response.age;
          this.form.birth = response.birth;
          this.form.gender = response.gender;
          this.form.description = response.description;
          this.form.twitter_id = response.twitter_id;
          this.form.facebook_id = response.facebook_id;
          this.form.wantedly_id = response.wantedly_id;
          this.form.github_id = response.github_id;
        });
    },

    async UpdateUser() {
      this.$axios.defaults.headers.common[
        "Authorization"
      ] = `Bearer ${this.jwt}`;
      this.$axios
        .$patch("/api/v1/mypage/my_pages/", {
          user: {
            username: this.form.username,
            gender: this.form.gender,
            age: this.form.age,
            description: this.form.description,
            twitter_id: this.form.twitter_id,
            facebook_id: this.form.facebook_id,
            wantedly_id: this.form.wantedly_id,
            github_id: this.form.github_id,
          },
        })
        .then((response) => {
          console.log(response);
          this.$buefy.toast.open({
            duration: 5000,
            message: "編集が完了しました",
            type: "is-success",
          });
          this.$router.push("/users/mypage");
          console.log(response);
        })
        .catch((error) => {
          if (error.response.status == "422") {
            this.ValidationErrors = error.response.data.validation;
          } else {
            this.$buefy.toast.open({
              duration: 5000,
              message: "サーバー内で問題が発生しました",
              type: "is-danger",
            });
          }
        });
    },

    hello(value) {
      console.log(value);
      this.form.birth = value;
    },
    parseDate(date) {
      console.log(date);
    },
    formatDate(date) {
      console.log(date);
    },
  },
};
</script>
