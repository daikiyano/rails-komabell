<template>
  <div>
    <MyPageTab />

    <div class="box">
      <h2><strong>基本情報</strong></h2>
      <article class="media">
        <div class="media-left">
          <figure class="image is-64x64">
            <img class="is-rounded" :src="user.image_url" alt="Image" />
          </figure>
          <b-button class="button" type="is-dark" @click="OpenModal"
            >アップロード</b-button
          >
        </div>
        <Modal
          :isModalForm="this.isModalForm"
          :FormComponent="this.FormComponent"
          @isCloseModal="closeModal"
          @ChangeImage="ChangeImage($event)"
          @UploadImage="UploadImage()"
        />

        <div class="media-content">
          <div class="content">
            <p>
              <strong>ユーザー名:{{ user.username }}</strong
              ><br />
              <small>性別:{{ user.gender }}</small>
              <br />
              <!-- <img :src="user" alt=""> -->
              {{ user.description }}
            </p>
            <img
              v-if="user.wantedly_id"
              src="~/assets/image/wantedly_mark.png"
              style="height: 40px"
              alt=""
            />
            <img
              v-if="user.twitter_id"
              src="https://img.icons8.com/color/48/000000/twitter-circled.png"
              style="height: 40px"
            />
            <img
              v-if="user.github_id"
              src="https://img.icons8.com/fluent/48/000000/github.png"
              style="height: 40px"
            />
            <img
              v-if="user.facebook_id"
              src="https://img.icons8.com/fluent/48/000000/facebook-new.png"
              style="height: 40px"
            />
          </div>
        </div>
      </article>
    </div>
    <div class="box">
      <article class="media">
        <div class="media-content">
          <div class="content">
            <h3>Github</h3>
            <div v-if="user.github_id">
              <div class="github-link">
                <i class="fab fa-github-square"></i>
                <a
                  :href="'https://github.com/' + user.github_id"
                  target="_blank"
                  >@{{ user.github_id }}</a
                >
              </div>
              <a :href="'https://github.com/' + user.github_id" target="_blank">
                <img
                  style="width: 100%"
                  :src="
                    'https://grass-graph.moshimo.works/images/' +
                    user.github_id +
                    '.png'
                  "
                />
              </a>
            </div>

            <h3>お気に入りサイト</h3>
            <!-- <div style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 10px 20px; text-align: center;">
  <img style="width: 170px; height: 220px;" src="https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/3513/9784297113513.jpg?_ex=200x200" alt="">
</div> -->
            <div
              v-for="(site, index) in this.sites"
              :key="index"
              style="
                height: 260px;
                width: 360px;
                box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);
                　display: inline-block;
                margin: 20px 20px;
                text-align: center;
                position: relative;
              "
            >
              <nuxt-link :to="`/sites/${site.id}`">
                <h1 class="title is-6">{{ site.title }}</h1>
                <img
                  class="is-rounded"
                  :src="site_images[index]"
                  alt="Image"
                  style=""
                />
              </nuxt-link>
              <div>{{ site.id }}</div>
            </div>

            <div
              v-for="(book, index) in this.books"
              :key="index"
              style="
                box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);
                　display: inline-block;
                margin: 20px 20px;
                text-align: center;
                position: relative;
              "
            >
              <nuxt-link :to="{ name: 'books-id', params: { id: book.isbn } }">
                <img
                  style="width: 170px; height: 220px"
                  :src="book.imageurl"
                  alt="TOP本"
                />
              </nuxt-link>
              <!-- <span style="position: absolute; left: 0; bottom: -20px; "><b-button type="is-info" size="is-small" @click="isModalForm=true; FormComponent='Memo'; BookDetail=book">メモを追加</b-button></span> -->
            </div>

            <h3>技術タグ</h3>

            <div
              v-for="(tag, index) in this.SkillTags"
              :key="index"
              style="display: inline; margin: 5px 5px; text-align: center"
            >
              <b-tag style="height: 30px">{{ tag.tag_name }}</b-tag>
            </div>
            <h3>技術レベル</h3>
            <div v-for="(tag, index) in this.SkillTags" :key="index">
              <div v-if="tag.skill > 0">
                <img
                  style="height: 60%; display: inline-block"
                  :src="tag.icon_url"
                  alt=""
                />
                <b-progress
                  size="is-large"
                  style="margin: 10px 10px"
                  type="is-success"
                  show-value
                  format="percent"
                  :value="tag.skill"
                >
                  <!-- <img style="height: 60%;" :src="tag.icon_url" alt=""> -->
                  {{ tag.tag_name }}
                </b-progress>
              </div>
            </div>
          </div>
        </div>
      </article>
    </div>
  </div>
</template>

<script>
import MyPageTab from "~/components/users/MyPageTab.vue";
import Modal from "~/components/Modal.vue";
import ImageUploadWithValidation from "~/components/Form/ImageUploadWithValidation.vue";
import * as firebase from "@/plugins/firebase";

export default {
  // middleware: "auth",
  components: {
    MyPageTab,
    Modal,
    ImageUploadWithValidation,
  },
  data() {
    return {
      user: "",
      image: "",
      email: "",
      SkillTags: [],
      croppieImage: "",
      file: "",
      cropped: null,
      user: "",
      books: null,
      isModalForm: false,
      FormComponent: "",
      form: {
        file: null,
      },
      sites: "",
      site_images: null,
      jwt: null,
    };
  },
  async created() {
    let self = this;
    firebase.auth().onAuthStateChanged((user) => {
      //ログインユーザーのfirebase情報をトークン形式で取得する
      if (user) {
        user.getIdToken().then(function (data) {
          console.log("data", data);
          self.jwt = data;
          self.fetchUser();
          self.FetchUserSkills();
          self.FetchBookShelf();
          self.FetchFavoriteSite();
        });
      } else {
        console.log("mounted");
        // User is signed out
        // ...
      }
    });
  },

  methods: {
    // ユーザー情報取得
    async fetchUser() {
      const ret = await this.$axios
        .$get("/api/v1/auto_login", {
          headers: { Authorization: `Bearer ${this.jwt}` },
        })
        .then((response) => {
          console.log(response);
          console.log("auto login");
          this.user = response;
          this.image = response.image;
        });
    },
    FetchUserSkills() {
      this.$axios.defaults.headers.common[
        "Authorization"
      ] = `Bearer ${this.jwt}`;
      this.$axios
        .$get("/api/v1/myskill/user_skill_categories/index")
        .then((res) => {
          this.SkillTags = res.data;
          //  this.skill_tags = [[7,"iOS",1], [9,"Android",2]]
          console.log(this.SkillTags);
        })
        .catch((error) => {
          if (error.response.status == "401") {
            console.log("tokenが無効です");
            this.$buefy.toast.open({
              duration: 5000,
              message: "サーバー内でも問題が発生しました",
              type: "is-danger",
            });
          }
        });
    },
    FetchBookShelf() {
      console.log("jwt", this.jwt);
      this.$axios.defaults.headers.common[
        "Authorization"
      ] = `Bearer ${this.jwt}`;
      this.$axios
        .$get("/api/v1/book/bookshelves")
        .then((res) => {
          console.log(res.bookshelves);
          this.books = res.bookshelves;
        })
        .catch((error) => {
          if (error.response.status) {
            console.log("tokenが無効です");
            this.$buefy.toast.open({
              duration: 5000,
              message: "サーバー内でも問題が発生しました",
              type: "is-danger",
            });
          }
        });
    },
    StatusMyPage(status) {
      if (status === 0) {
        this.MyPageComponent = "MyPage";
      } else if (status === 1) {
        // this.MyPageComponent = "Edit"
        this.$router.push("/users/edit");
      } else if (status === 2) {
        this.MyPageComponent = "MySkill";
      }
    },
    OpenModal() {
      this.isModalForm = true;
      this.FormComponent = "ImageUploadWithValidation";
    },
    closeModal() {
      this.isModalForm = false;
    },
    ChangeImage(image) {
      console.log("hey");

      this.form.file = image;
      console.log(this.form);
    },
    FetchFavoriteSite() {
      console.log("aaaaaa");
      this.$axios
        .$get("/api/v1/user_favorites")
        .then((res) => {
          console.log(res.data);
          this.sites = res.data;
          this.site_images = res.images;
        })
        .catch((error) => {
          if (error.response.status == "401") {
            console.log("tokenが無効です");
            this.$buefy.toast.open({
              duration: 5000,
              message: "サーバー内でも問題が発生しました",
              type: "is-danger",
            });
          }
        });
    },
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
            this.$router.push("/users/mypage");
            this.isModalForm = false;
            this.fetchUser();
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
  },
};
</script>

// myPageStatus='"MySkills"'