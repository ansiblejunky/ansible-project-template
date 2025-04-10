#!/usr/bin/env python

class FilterModule:
    def filters(self):
        return {
            "a_filter": self.a_filter,
            "another_filter": self.b_filter,
        }

    def a_filter(self, a_variable: str) -> str:
        return a_variable + " CRAZY NEW FILTER"

    def b_filter(self, a_variable: str, another_variable: str, yet_another_variable: str) -> str:
        return a_variable + " - " + another_variable + " - " + yet_another_variable
