<template>
  <div>
    <div class="card-content">
      <div>
        <section class="modal-card-body">
          <header class="modal-card-head">
              <p class="modal-card-title">読書メモ</p>
          </header>
          <section>
            <!-- {{BookDetail.memo}} -->
              <!-- あああ{{BookDetail.title}}
              <img style="width: 170px; height: 220px;" :src="BookDetail.imageurl" alt="TOP本">  -->
              <div v-if="this.step === 1">
                <div class="mavonEditor">
                <mavon-editor
                  v-model="value"
                  language="ja"
                  :subfield="false"
                  defaultOpen="preview"
                 :toolbars="false"
                />
                </div>
              </div>
              <div v-if="this.step === 2">
                <div class="mavonEditor">
                  <mavon-editor :toolbars="markdownOption" :language="'ja'" @change="changeText" v-model="value"/>
                  <!-- {{mdText}} -->
                </div>
              </div>
          </section>
          <footer class="modal-card-foot">
            <div v-if="this.step === 1">
              <button class="button" type="is-dark" @click="OpenMarkdown()">メモを編集する</button>
              <button class="button" type="is-dark" @click="close()">閉じる</button>
            </div>
            <div v-if="this.step === 2">
              <button class="button" type="is-dark" @click="UpdateMemo(BookDetail.isbn)">メモを更新する</button>
              <button class="button" type="is-dark" @click="close()">閉じる</button>
            </div>
          </footer>
        </section>
     
       
      </div>
      </div>
   
  
  </div>
</template>

<script>
  export default {
    name: 'Memo',
    props: {
        'BookDetail': {
            type: Object,
            required: true
        },
        
        },
    data() {
    return {

      markdownOption: {
        bold: true,
        italic: true,
        header: true,
        underline: true,
        strikethrough: true,
        mark: true,
        superscript: true,
        subscript: true,
        quote: true,
        ol: true,
        ul: true,
        link: true,
        imagelink: false,
        code: true,
        table: true,
        fullscreen: true,
        readmodel: true,
        htmlcode: true,
        help: true,     
      },
      value: "#### Markdown",
      mdText: "",
      htmlText: `<h2>Markdown</h2> <blockquote> <p>aaaaaaa </blockquote>`,
      step : 1

    }
  },
    created() {
      this.setMemo()
    },
    methods: {
      setMemo () {
        console.log()
        if (this.BookDetail.memo) {
          this.value = this.BookDetail.memo
        }
      },
      close () {
        this.$emit('isCloseModal', false)
      },
      
      changeText(value, reder) {
      this.mdText = value; 
      this.htmlText = reder;
    },
    UpdateMemo (isbn) {
      this.$emit('UpdateMemo', [this.mdText,isbn])
    },
    OpenMarkdown () {
      this.step = 2
    }
    }  
  }
</script>


<style>
.modal-card-body {
    box-shadow: 0 2px 10px rgba(0,0,0,.15);
}
.modal-card-head {
    background-color: white;
    border-bottom: 1px solid white;
}

.modal-card-foot {
    background-color: white;
    border-top: 1px solid white;
}
</style>