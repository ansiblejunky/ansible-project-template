#!/usr/bin/python

class FilterModule(object):
    def filters(self):
        return {
            'a_filter': self.a_filter,
            'another_filter': self.b_filter
        }

    def a_filter(self, a_variable):
        a_new_variable = a_variable + ' CRAZY NEW FILTER'
        return a_new_variable

    def b_filter(self, a_variable, another_variable, yet_another_variable):
        a_new_variable = a_variable + ' - ' + another_variable + ' - ' + yet_another_variable
        return a_new_variable