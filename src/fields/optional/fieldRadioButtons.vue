<template>
    <p :class="wrapperClasses" :disabled="disabled">
        <a v-for="item in items" class="button"
               :disabled="disabled"
               :name="id"
               @click="onSelection($event, item)"
               :value="getItemValue(item)"
               :checked="getItemIsChecked(item)"
               :class="buttonClasses(item)">
            <span>{{ getItemName(item) }}</span>
        </a>
    </p>
</template>

<script>
    import {isObject, isNil, isString} from "lodash";
    import abstractField from "../abstractField";

    export default {
        mixins: [abstractField],
        computed: {
            items() {
                let values = this.schema.values;
                if (typeof(values) == "function") {
                    return values.apply(this, [this.model, this.schema]);
                } else {
                    return values;
                }
            },
            id(){
                return this.schema.model;
            },
            wrapperClasses: function() {
                if(isString(this.schema.wrapperClass)) {
                    return this.schema.wrapperClass;
                } else {
                    return "control has-addons";
                }
            }
        },

        methods: {
            getItemIsChecked(item) {
                if(this.schema.multiSelect) {
                    return (this.value && this.value.indexOf(this.getItemID(item)) != -1);
                }

                let currentValue;
                if (isObject(item) && this.schema.radiosOptions.value && item[this.schema.radiosOptions.value]) {
                    currentValue = item[this.schema.radiosOptions.value];
                } else {
                    currentValue = item;
                }

                return (currentValue === this.value);
            },
            onSelection(event, item) {
                if (isNil(this.value) && this.schema.multiSelect)
					this.value = [];

                if(this.getItemIsChecked(item)) {
                    // unckeck and remove from list if multi
                    if(this.schema.multiSelect) {
                        // only remove if allowed baesd on required && min value
                        // this needs more thought - corner cases need discovery
                        //if(!(this.schema.required && this.value.length > 1) || (!isNil(this.schema.min) && this.value.length >= this.schema.min))
                        this.value.splice(this.value.indexOf(this.getItemID(item)), 1);
                    } else if (!this.schema.required) {
                        this.value = "";
                    }
                } else {

                    if (isObject(item) && this.schema.radiosOptions.value && item[this.schema.radiosOptions.value]) {
                        if (this.schema.multiSelect) {
                            this.value.push(item[this.schema.radiosOptions.value]);
                        } else {
                            this.value = item[this.schema.radiosOptions.value];
                        }
                    } else {
                        if (this.schema.multiSelect) {
                            this.value.push(item);
                        } else {
                            this.value = item;
                        }
                    }
                }

            },
            getItemValue(item) {
                if (isObject(item) && this.schema.radiosOptions.value && item[this.schema.radiosOptions.value]) {
                    return item[this.schema.radiosOptions.value];
                }

                return item;
            },
            getItemName(item) {
                if (isObject(item) && this.schema.radiosOptions.name && item[this.schema.radiosOptions.name]) {
                    return item[this.schema.radiosOptions.name];
                }

                return item;
            },
            getItemID(item) {
				if (isObject(item) && item.id)
					return item.id;

				return item;
			},
            buttonClasses(item) {
                // this is a method instead of computed because checked state needs evaluated
                let classes = "";

                if (this.getItemIsChecked(item)) {
                    if(isString(this.schema.activeClasses)) {
                        classes = this.schema.activeClasses;
                    } else {
                        classes = "is-info is-active";
                    }
                } else if (isString(this.schema.inactiveClasses)) {
                    classes = this.schema.inactiveClasses;
                }

                // additional classes such as size and style
                if (isString(this.schema.buttonClasses)) {
                    classes += " " + this.schema.buttonClasses;
                }

                //this.$log(classes);
                return classes.trim();
            }
        }
    };
</script>

<style lang="sass">

</style>
