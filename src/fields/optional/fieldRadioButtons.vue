<template>
    <p class="control has-addons" style="display: block;" :disabled="disabled">
        <a v-for="item in items" class="button"
               :disabled="disabled"
               :name="id"
               @click="onSelection($event, item)"
               :value="getItemValue(item)"
               :checked="getItemIsChecked(item)"
               v-bind:class="classes(item)">
            <span>{{ getItemName(item) }}</span>
        </a>
    </p>
</template>

<script>
    import {isObject, isNil} from "lodash";
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
            classes(item) {
                let classes = [];

                if(this.getItemIsChecked(item)) {
                    classes.push('is-active');

                    if (this.schema.activeColor) {
                        switch (this.schema.activeColor) {
                            case 'primary':
                                classes.push('is-primary');
                                break;
                            case 'info':
                                classes.push('is-info');
                                break;
                            case 'success':
                                classes.push('is-success');
                                break;
                            case 'warning':
                                classes.push('is-warning');
                                break;
                            case 'danger':
                                classes.push('is-danger');
                                break;
                            case 'white':
                                classes.push('is-white');
                                break;
                            case 'light':
                                classes.push('is-light');
                                break;
                            case 'dark':
                                classes.push('is-dark');
                                break;
                            case 'black':
                                classes.push('is-black');
                                break;
                            case 'link':
                                classes.push('is-link');
                                break;

                            default:
                                classes.push('is-info');
                                break;
                        }
                    }
                } else {
                    if (this.schema.inactiveColor && this.schema.inactiveColor != this.schema.activeColor) {
                        switch (this.schema.inactiveColor) {
                            case 'primary':
                                classes.push('is-primary');
                                break;
                            case 'info':
                                classes.push('is-info');
                                break;
                            case 'success':
                                classes.push('is-success');
                                break;
                            case 'warning':
                                classes.push('is-warning');
                                break;
                            case 'danger':
                                classes.push('is-danger');
                                break;
                            case 'white':
                                classes.push('is-white');
                                break;
                            case 'light':
                                classes.push('is-light');
                                break;
                            case 'dark':
                                classes.push('is-dark');
                                break;
                            case 'black':
                                classes.push('is-black');
                                break;
                            case 'link':
                                classes.push('is-link');
                                break;

                            default:
                                break;
                        }
                    }
                }

                if (this.schema.buttonSize) {
                    switch (this.schema.buttonSize) {
                        case 'small':
                            classes.push('is-small');
                            break;
                        case 'medium':
                            classes.push('is-medium');
                            break;
                        case 'large':
                            classes.push('is-large');
                            break;

                        default:
                            break;
                    }
                }

                if (this.schema.buttonStyle) {
                    if(this.schema.buttonStyle == 'outlined')
                        classes.push('is-outlined');

                    if(this.schema.buttonStyle == 'inverted')
                        classes.push('is-inverted');
                }

                //this.$log(classes);
                return classes;
            }
        }
    };
</script>

<style lang="sass">

</style>
