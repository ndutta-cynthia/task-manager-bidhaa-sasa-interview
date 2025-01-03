import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class TaskForm extends NavigationMixin(LightningElement) {
    @api recordId;
    dueDateError;

    get cardTitle() {
        return this.recordId ? 'Edit Task' : 'New Task';
    }

    handleSubmit(event) {
        try {
            const fields = event.detail.fields;
            
            // Validate due date is not in the past
            if (fields.Due_Date__c) {
                const dueDate = new Date(fields.Due_Date__c);
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                
                if (dueDate < today) {
                    event.preventDefault();
                    this.dueDateError = 'Due date cannot be in the past';
                    return;
                }
            }
            this.dueDateError = undefined;
        } catch (error) {
            // Silently handle any errors
            console.error('Submit error:', error);
        }
    }

    handleSuccess(event) {
        try {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: this.recordId ? 'Task updated successfully' : 'Task created successfully',
                    variant: 'success'
                })
            );

            this.dispatchEvent(new CustomEvent('taskupdated'));

            if (!this.recordId) {
                this.template.querySelector('lightning-record-edit-form').reset();
            }
        } catch (error) {
            // Silently handle any errors
            console.error('Success handler error:', error);
        }
    }

    handleError(event) {
        // Just log the error
        console.error('Form Error:', JSON.stringify(event.detail));
    }

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }
} 
