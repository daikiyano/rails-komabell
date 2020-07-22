<template>
    <section>
        <b-modal :active="isModalForm"
                 has-modal-card
                 trap-focus
                 :destroy-on-hide="false"
                 aria-role="dialog"
                 width="1000"
                 :on-cancel="closeModal"
                 scroll="clip"
                 aria-modal>
        <div class="modal-card" style="width: auto">
          <component 
            :is="FormComponent"
            :BookDetail="BookDetail"
            @isCloseModal="closeModal"
            @ChangeForm="$emit('ChangeForm', $event)"
            @UpdateMemo="$emit('UpdateMemo', $event)"
            @ChangeImage="$emit('ChangeImage', $event)"
            @UploadImage="$emit('UploadImage')"
          >
          </component>
        </div>
      </b-modal>
    </section>
</template>

<script>
import Login from '~/components/Login.vue'
import SignUp from '~/components/SignUp.vue'
import Memo from '~/components/BookShelf/Memo.vue'
import ImageUploadWithValidation from '~/components/Form/ImageUploadWithValidation.vue'
    export default {
        name: 'Modal',
        components: {
            Login,
            SignUp,
            Memo,
            ImageUploadWithValidation
        },
        props: {
            'isModalForm': {
            type: Boolean,
            required: true
        },
        'FormComponent': {
            type: String,
            required: true
        },
        'BookDetail': {
            type: Object
        },
        
        },
        data() {
            return {
            }
        },
        methods: {
            closeModal () {
                this.$emit('isCloseModal', false)
            },
          
        }
    }
</script>

<style>
.modal-background {
background-color:rgba(255,255,255,.97);
}
card-content
/* .modal-card-body { */

.modal-card-body {
    background-color: red;
    /* overflow: visible !important; */
    

}
.modal-card {
    overflow: auto;
}

</style>

