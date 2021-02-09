<template>
<div>
  <div>
    <img class="is-centered" src="@/assets/image/top_logo.png">
  </div>

  <h1 class="title is-3 title-line">ProHubの特徴</h1>
  <div class="content is-medium columns is-desktop Headline">
    <div class="column">
      <h1 class="title is-4 title-line" style="text-align: center;">ProHubとは</h1>
      <p style="padding: 30px; auto;">
        <strong>ProHubではオンライン上のプログラミング学習サービスのまとめサイトです。
          プログラミングを始めたいけど、どうやって始めれば良いか分からない。そんなプログラミング初心者にはぴったりのサイトです。
          </strong>
      </p>
    </div>
<h2>Sign up</h2>
    <input type="email" placeholder="Email" v-model="email">
    <input type="password" placeholder="Password" v-model="password">
    <button @click="signUp">Register</button>
    <button @click="signIn">ログイン</button>
    <button @click="logOut">ログアウト</button>
    <div class="column">
      <img class="is-centered" src="@/assets/image/top2.png">
    </div>
      </div>
    <div class="content is-medium columns is-desktop">
    <div class="column">
      <img class="is-centered" src="@/assets/image/top3.png">
    </div>
    <div class="column">
      <h1 class="title is-4 title-line" style="text-align: center;">どんな人向け？</h1>
      <p style="padding: 30px; auto;">
        <strong>
          プログラミングを始めたいけど、どうやって始めれば良いか分からない。そんなプログラミング初心者にはぴったりのサイトです。
          </strong>
      </p>
    </div>
  </div>


  <h1 class="title is-3 title-line">About</h1>

 <section class="section" style="text-align: center;">
    <main style="top: 50px; position: relative;">
      <h1 class="title is-3 title-line">
      <b-icon
        icon="book-open-variant"
        size="is-medium"
      />
      学習サイト一覧
    </h1>
    <!-- {{this.$auth.user}}aa -->
    <section>
        <b-tabs position="is-centered" @input="StatusSiteCategory" class="block">
            <b-tab-item label="All"></b-tab-item>
            <b-tab-item label="Popular"></b-tab-item>
        </b-tabs>
    </section>
    <!-- height: 260px; width:360px; -->
      <div class="column is-5" v-for="(site, index) in this.sites" :key="index" style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 20px 20px; text-align: center; position: relative;">
        <nuxt-link :to="`/sites/${site.id}`">
          <h1 class="title is-6">{{site.title}}</h1>
          <img class="is-rounded" :src="files[index]" alt="Image" style="">
        </nuxt-link>  
        <div>
         
        </div>
      </div>
     
    </main>
    </section>
  <section class="section" style="text-align: center;">
    <h1 class="title is-4 title-line">
      <b-icon
        icon="book-open-variant"
        size="is-medium"
      />
      技術書籍
    </h1>
    <div class="columns is-mobile">
      <Modal :isModalForm="this.isModalForm" 
             :FormComponent="this.FormComponent"   
             @isCloseModal="closeModal" 
             @ChangeForm="ChangeForm($event)" 
      />
    </div>
    <div>
      <h1>技術カテゴリ</h1>
      <div style="background-color: white;">
        <div v-for="(tag,index) in this.CategoryTags.slice(0,this.CategoryCount)" :key="index" style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline; margin: 10px 20px; text-align: center;">
            <span style="cursor: pointer;" @click="ChangeCategory(tag.tag_name)"><b-tag>{{tag.tag_name}}</b-tag></span>
          <!-- <img @click="ChangeCategory(tag.tag_name)" :src="tag.icon_url" alt="TOP本"> -->
        </div>  
      </div>
      <a @click="ChangeCategoryCount">
          {{  this.ShowTagCount }}
      </a>
      <div>
        <h1 class="title is-4">書籍一覧</h1>
        <div v-for="(book,index) in this.books" :key="index" style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 20px 20px; text-align: center; position: relative;">
          
          <nuxt-link :to="{name:'books-id',params:{id:book.params.isbn}}">
          <img style="width: 80px; height: 120px;" :src="book.params.largeImageUrl" alt="TOP本"> 
          </nuxt-link>  
          <!-- <span style="position: absolute; left: 0; bottom: -20px; "><b-button type="is-info" size="is-small" @click="PostBookShelf(book.params.isbn,book.params.largeImageUrl)">本棚に登録</b-button></span> -->
        </div>
      </div>
      
    </div>
  </section>
  </div>
  </div>
  </div>
 
</template>

<script>
import Modal from "~/components/Modal.vue";
import * as firebase from "@/plugins/firebase";

export default {
  name: "HomePage",

  components: {
    Modal,
  },
  data() {
    return {
      email: "",
      error: "",
      isModalForm: false,
      FormComponent: "",
      books: "",
      CategoryTags: [],
      CategoryCount: 30,
      IsCategoryTag: false,
      ShowTagCount: "More ...",
      sites: "",
      files: null,
      CheckUserLike: false,
      password: "",
      tmpUser: null,
      jwt: null,
    };
  },
  async mounted() {
    let self = this;
    firebase.auth().onAuthStateChanged(async (user) => {
      if (user) {
        user.getIdToken().then(function (data) {
          console.log(data);
          self.jwt = data;
        });
        // const res = await axios.get(`/v1/users?uid=${user.uid}`)
        // this.user = res.data
      }
    });
  },
  created() {
    this.FetchSites();
    this.FetchCategories();
    this.fetchRecommendedBook();
    this.checkLoginToken();
  },
  methods: {
    // 初回おすすめ本取得
    fetchRecommendedBook() {
      this.$axios
        .$get("/api/v1/search/001005")
        .then((res) => {
          this.books = "";
          console.log(res.tag);
          this.books = res.data;
          this.tags = res.tag;
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

    // ログイン時のトークンチェック
    checkLoginToken() {
      this.$axios.defaults.headers.common[
        "Authorization"
      ] = `Bearer ${localStorage.idToken}`;
      if (this.$route.query.token) {
        this.$axios
          .$post("/api/v1/token_check", {
            token: this.$route.query.token,
          })
          .then((res) => {
            this.email = res.email;
            console.log(res.email);
            console.log(this.email);
            if (this.$auth.loggedIn === false) {
              this.login();
              this.$router.push("/");
              this.$buefy.toast.open({
                duration: 5000,
                message: "ようこそ！！",
                type: "is-success",
              });
            }
          })
          .catch((error) => {
            if (error.response.status == "401") {
              console.log("tokenが無効です");
              this.$buefy.toast.open({
                duration: 5000,
                message: "トークンが無効です",
                type: "is-danger",
              });
              this.isModalForm = true;
              this.FormComponent = "Login";
            }
          });
      }
    },
    StatusSiteCategory(status) {
      if (status === 0) {
        this.FetchSites();
      } else if (status == 1) {
        this.FetchSiteRank();
      }
      console.log(status);
    },
    FetchSiteRank() {
      // this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
      this.$axios
        .$get("/api/v1/site_rank")
        .then((res) => {
          console.log(res);
          this.sites = res.data;
          this.files = res.images;
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
    async login() {
      await this.$auth
        .loginWith("user", {
          data: {
            email: this.email,
          },
        })
        .then((response) => {
          console.log(response.data.token);
          localStorage.setItem("idToken", response.data.token);
        })
        .catch((error) => {
          console.log(error);
        });
    },
    logout() {
      this.$auth.logout();
      localStorage.clear();
      console.log(this.$auth.loggedIn);
    },
    closeModal() {
      this.isModalForm = false;
    },
    ChangeForm(FormComponent) {
      console.log(FormComponent);
      this.FormComponent = FormComponent;
    },
    FetchCategories() {
      console.log(process.env.BASE_URL);
      this.$axios
        .$get("/api/v1/fetch_categories")
        .then((res) => {
          console.log(res.tag);
          this.CategoryTags = res.tag;
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
    ChangeCategory(TagName) {
      console.log(TagName);
      this.$axios.defaults.headers.common[
        "Authorization"
      ] = `Bearer ${localStorage.idToken}`;
      this.$axios
        .$get(`/api/v1/search/${TagName}`)
        .then((res) => {
          this.books = "";
          this.books = res.data;
          console.log(res.data);
          console.log(TagName);
        })
        .catch((error) => {
          if (error.response.status == "401") {
            console.log("tokenが無効です");
            // this.error = "Tokenが無効です"
            this.$buefy.toast.open({
              duration: 5000,
              message: "サーバー内でも問題が発生しました",
              type: "is-danger",
            });
          }
        });
    },

    ChangeCategoryCount() {
      switch (this.CategoryCount) {
        case 30:
          this.CategoryCount = 100;
          this.IsCategoryTag = true;
          break;
        case 100:
          this.CategoryCount = 200;
          break;
        case 200:
          this.CategoryCount = 300;
          break;
        case 300:
          this.CategoryCount = 400;
          this.ShowTagCount = "Close ...";
          break;
        case 400:
          this.CategoryCount = 30;
          this.IsCategoryTag = false;
          this.ShowTagCount = "More ...";
          window.scrollTo({
            top: 0,
            behavior: "smooth",
          });
          break;
      }
    },
    FetchSites() {
      this.$axios.defaults.headers.common[
        "Authorization"
      ] = `Bearer ${this.jwt}`;
      this.$axios
        .$get("/api/v1/sites")
        .then((res) => {
          this.sites = res.data;
          this.files = res.images;

          //  this.skill_tags = [[7,"iOS",1], [9,"Android",2]]
          console.log(res);
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
    PostSiteFavorite(id) {
      console.log("hey");
      this.$axios.defaults.headers.common[
        "Authorization"
      ] = `Bearer ${localStorage.idToken}`;
      this.$axios
        .$post(`/api/v1/sites/${id}/site_favorites`, {
          // site_favorites : {
          //   isbn : lsbn,
          //   imageurl : imageurl
          // }
        })
        .then((res) => {
          console.log(res.data);
          this.IsFavorite = true;
          this.$buefy.toast.open({
            duration: 1000,
            message: "お気に入り登録しました",
            type: "is-info",
          });
        })
        .catch((error) => {
          if (error.response.status == "401") {
            this.$buefy.toast.open({
              duration: 5000,
              message: "サーバー内でも問題が発生しました",
              type: "is-danger",
            });
          }
        });
    },
    signUp() {
      console.log(firebase.auth());
      firebase
        .auth()
        .createUserWithEmailAndPassword(this.email, this.password)
        .then((user) => {
          this.test(user);
          console.log(user);
        })
        .catch((error) => {
          alert(error.message);
        });
    },

    async test(user) {
      console.log(user.user.uid);

      const idToken = await firebase.auth().currentUser.getIdToken();
      localStorage.setItem("token", idToken);
      console.log(idToken);
      // this.$axios
      //   .$post("/api/v1/create", data)
      //   .then(() => {
      //     console.log("clrea");
      //   })
      //   .catch((error) => {
      //     if (error.response) {
      //       console.log(error.response);
      //       this.errors = "メールアドレスは既に登録されています";
      //     } else {
      //       this.serverError = "サーバー内で問題が発生しました。";
      //     }
      //   });
    },
    signIn() {
      firebase
        .auth()
        .signInWithEmailAndPassword(this.email, this.password)
        .then(
          (user) => {
            this.test(user);
            alert(user.user.uid);
            this.tmpUser = user;
            this.$router.push("/");
          },
          (err) => {
            alert(err.message);
          }
        );
    },
    logOut() {
      firebase
        .auth()
        .signOut()
        .then(() => {
          alert("logout seccessful!");
          window.location.href = "/";
        })
        .catch((e) => {
          console.log(e);
          console.log("an error happened");
        });
    },
  },
};
</script>

<style>
.title-line {
  position: relative;
  display: block;
  font-size: 30px;
  margin: 10px auto;
  text-align: center;
}
.title-line::after {
  content: "";
  display: block;
  width: 60px;
  height: 5px;
  margin: 8px auto 0 auto;
  background-color: #64bc6e;
}
.Headline {
  animation: SlideIn 1.6s;
}

/* CSSアニメーションの設定 */
@keyframes SlideIn {
  0% {
    opacity: 0; /*初期状態では透明に*/
    transform: translateX(64px);
  }
  100% {
    opacity: 1;
    transform: translateX(0);
  }
}
</style>

// /api/v1/book/bookshelves